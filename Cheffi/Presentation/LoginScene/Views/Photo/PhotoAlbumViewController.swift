//
//  PhotoAlbumViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import UIKit
import Combine

class PhotoAlbumViewController: UIViewController {
    static func instance<T: PhotoAlbumViewController>(viewModel: PhotoAlbumViewModelType) -> T {
        let vc: T = .instance(storyboardName: .photoAlbum)
        vc.viewModel = viewModel
        return vc
    }
    
    enum Constants {
        static let spacing: CGFloat = 4.0
    }
    
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var latestItemsButton: UIButton!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel: PhotoAlbumViewModelType!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        bindViewModel()
    }
    
    // MARK: - Private
    private func setupViews() {
        latestItemsButton.setTitle("최근 항목", for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(nibWithCellClass: PhotoCell.self)
        collectionView.allowsMultipleSelection = true
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: PhotoCell.self, for: indexPath)
            let isHidden: Bool = !(indexPath.item == 0)
            cell.isHiddenCameraImage(isHidden)
            cell.isHiddenSelectionImage(!isHidden)
            if let imageData = Data(base64Encoded: identifier, options: .ignoreUnknownCharacters), let image = UIImage(data: imageData) {

                cell.configure(with: image)
            }
            return cell
        }
    }
    
    private func bindViewModel() {
        viewModel.photoIdentifiersPublisher
            .sink { [weak self] identifiers in
                self?.applySnapshot(identifiers: identifiers)
            }
            .store(in: &cancellables)
        
        viewModel.isLatestItemsButtonSelectedPublisher
            .sink { [weak self] isSelected in
                self?.arrowImageView.image = isSelected ? UIImage(named: "icArrowUp") : UIImage(named: "icArrowDown")
            }
            .store(in: &cancellables)
        
        viewModel.errorSubject
            .sink { [weak self] errorMessage in
                DispatchQueue.main.async {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
        
        viewModel.downloadingAssetsPublisher
            .sink { [weak self] downloadingIdentifiers in
                self?.updateLoadingIndicators(for: downloadingIdentifiers)
            }
            .store(in: &cancellables)
        
        viewModel.fetchPhotos()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "OK", style: .default) { _ in
            // 사용자가 "OK" 버튼을 누르면 앱의 설정 화면으로
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
        
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }

    
    private func applySnapshot(identifiers: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems([""] + identifiers)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateNextButtonState() {
        if let selectedItems = collectionView.indexPathsForSelectedItems, !selectedItems.isEmpty {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    private func updateLoadingIndicators(for downloadingIdentifiers: Set<String>) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell, let assetIdentifier = dataSource?.itemIdentifier(for: indexPath) {
                if downloadingIdentifiers.contains(assetIdentifier) {
                    cell.showLoadingIndicator()
                } else {
                    cell.hideLoadingIndicator()
                }
            }
        }
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapColse(_ sender: UIButton) {
        self.dismissOne()
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
#if DEBUG
        print("다음은 크롭 화면")
#endif
    }
    
    @IBAction private func didTapLatestItems(_ sender: UIButton) {
        viewModel.toggleLatestItemsButton()
        // TODO: - 최근 항목 리스트 나오는 View 추가
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.width-6) / 3
        return CGSize(width: width, height: 123)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // TODO: Handle camera button tap
#if DEBUG
            print("카메라 오픈")
#endif
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                // 다른 셀이 이미 선택되어 있는 경우, 그 셀의 선택을 해제
                if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
                    for selectedIndexPath in selectedIndexPaths {
                        if selectedIndexPath != indexPath {
                            collectionView.deselectItem(at: selectedIndexPath, animated: true)
                            if let selectedCell = collectionView.cellForItem(at: selectedIndexPath) as? PhotoCell {
                                selectedCell.resetSelectionState()
                            }
                        }
                    }
                }
                cell.updateSelectionImage()
                updateNextButtonState()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.resetSelectionState()
            updateNextButtonState()
        }
    }
}
