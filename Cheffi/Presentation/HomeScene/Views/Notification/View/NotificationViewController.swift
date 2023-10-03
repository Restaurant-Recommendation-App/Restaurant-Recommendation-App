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
    
    private var viewModel: NotificationViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    private var notifications: [Notification] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet private weak var headerView: NotificationHeaderView!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum Constants {
        static let cellHeight: CGFloat = 106
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        
        headerView.didTapDeleteHandler = { [weak self] in
#if DEBUG
            print("삭제 버튼")
#endif
        }
        
        viewModel.notificationsPublisher
            .sink { [weak self] notifications in
                self?.notifications = notifications
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
        
        viewModel.viewDidLoad()
    }
    
    private func showError(_ error: DataTransferError) {
#if DEBUG
        print("-------------------- ERROR ")
        print(error)
        print("--------------------")
#endif
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismissOrPop(amimated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NotificationCell.self, for: indexPath)
        cell.configure(with: notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
#if DEBUG
        print("-----------------------------------------")
        print("선택 된 알림")
        print(notification)
        print("-----------------------------------------")
#endif
    }
}
