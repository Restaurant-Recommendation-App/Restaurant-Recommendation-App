//
//  NotificationViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import UIKit
import Combine

class NotificationViewController: UIViewController {
    static func instance<T: NotificationViewController>(viewModel: NotificationViewModelType) -> T {
        let vc: T = .instance(storyboardName: .notification)
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    private enum Constants {
        static let cellHeight: CGFloat = 106
        static let deleteViewHeight: CGFloat = 80.0
    }
    
    private var viewModel: NotificationViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet private weak var headerView: NotificationHeaderView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteSelectionButton: UIButton!
    @IBOutlet private weak var deleteViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    deinit {
#if DEBUG
        print("NotificationViewController deinitialized")
#endif
    }
    
    // MARK: - Private
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: NotificationCell.self)
        
        cancelButton.setTitle("취소".localized(), for: .normal)
        cancelButton.titleLabel?.font = Fonts.suit.weight600.size(18)
        cancelButton.setTitleColor(.cheffiGray6, for: .normal)
        cancelButton.tintColor = .cheffiGray6
        cancelButton.layerBorderColor = .cheffiGray1
        cancelButton.layerCornerRadius = 10
        cancelButton.layerBorderWidth = 1
        
        deleteSelectionButton.isEnabled = false
        deleteSelectionButton.setTitle("선택항목 삭제".localized(), for: .normal)
        deleteSelectionButton.titleLabel?.font = Fonts.suit.weight600.size(18)
        deleteSelectionButton.setTitleColor(.cheffiGray5, for: .disabled)
        deleteSelectionButton.setTitleColor(.white, for: .normal)
        deleteSelectionButton.backgroundColor = .cheffiGray1
        deleteSelectionButton.layerCornerRadius = 10
        
        updateDeleteView(false)
        
        headerView.didTapDeleteHandler = { [weak self] isSelected in
            if !isSelected {
                // 전체 삭제
                self?.viewModel.showPopup(text: "모든 알림 삭제",
                                          subText: "모든 알림이 삭제됩니다.",
                                          keywrod: "",
                                          popupState: .deleteNotification,
                                          leftButtonTitle: "취소하기",
                                          rightButtonTitle: "삭제하기",
                                          leftHandler: nil,
                                          rightHandler: { [weak self] in
                    self?.deleteSelectionCells(isAllDelete: true)
                    self?.updateDeleteView(false)
                })
            } else {
                // 삭제 모드
                self?.updateDeleteView(true)
            }
        }
    }
    
    private func setupBindings() {
        viewModel.notificationsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notifications in
                self?.showEmptyView(notifications.isEmpty)
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
        
        viewModel.isDeletingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isDeleting in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.selectIndexPathsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectIndexPaths in
                self?.updateDeleteSelectionButton(isEnabled: !selectIndexPaths.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: DataTransferError) {
#if DEBUG
        print("-------------------- ERROR ")
        print(error)
        print("--------------------")
#endif
        showEmptyView(true)
    }
    
    private func updateDeleteView(_ isEnable: Bool) {
        viewModel.setDeleting(isEnable)
        deleteViewHeightConstraint.constant = isEnable ? Constants.deleteViewHeight : 0.0
        if isEnable == false {
            headerView.disableDeleteButton()
        }
    }
    
    private func updateDeleteSelectionButton(isEnabled: Bool) {
        deleteSelectionButton.isEnabled = isEnabled
        deleteSelectionButton.backgroundColor = isEnabled ? .mainCTA : .cheffiGray1
        deleteSelectionButton.titleLabel?.textColor = isEnabled ? .white : .cheffiGray5
    }
    
    private func deleteSelectionCells(isAllDelete: Bool = false) {
        if isAllDelete {
            // 알림 리스트 초기화
            viewModel.notificationRemoveAll()
        } else {
            let indexPaths = viewModel.selectIndexPaths.sorted(by: >)
            viewModel.notificationRemove(at: indexPaths)
        }
    }
    
    private func showEmptyView(_ isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        headerView.setDeleteButtonVisibility(isHidden: isEmpty)
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismissOrPop(amimated: true)
    }
    
    @IBAction func didTapDeleteCancel(_ sender: UIButton) {
        updateDeleteView(false)
    }
    
    @IBAction func didTapDeleteSelection(_ seder: UIButton) {
        deleteSelectionCells()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNotifications
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NotificationCell.self, for: indexPath)
        if let notification = viewModel.notification(at: indexPath.row) {
            cell.configure(with: notification, isDeleting: viewModel.isDeleting)
            cell.updateContentViewBackgroundColor(viewModel.isReadNotification(at: notification.id))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NotificationCell else { return }
        let isDeleting: Bool = viewModel.isDeleting
        if isDeleting {
            viewModel.selectIndexPathAppend(indexPath)
            cell.updateSelectionButton()
        } else {
            if let notification = viewModel.notification(at: indexPath.row) {
                if viewModel.isReadNotification(at: notification.id) == false {
                    viewModel.readNotoficationAppend(at: notification.id)
                }
            }
            
            cell.updateContentViewBackgroundColor(true)
            
            // TODO: - 해당 페이지로 이동
            print("---------------------------------------")
            print(viewModel.notification(at: indexPath.row)?.content ?? "-")
            print("---------------------------------------")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NotificationCell else { return }
        let isDeleting: Bool = viewModel.isDeleting
        if isDeleting, let _ = viewModel.selectIndexPaths.firstIndex(of: indexPath) {
            viewModel.selectIndexPathRemove(at: [indexPath])
            cell.updateSelectionButton()
        }
    }
}


extension NotificationViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentOffsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let height = tableView.frame.height
        let actualHeight = (contentHeight - height > 0) ? contentHeight - height : 0

        if contentOffsetY > actualHeight {
            viewModel.scrolledToBottom()
        }
    }
}
