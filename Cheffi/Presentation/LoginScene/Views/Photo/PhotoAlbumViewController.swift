//
//  PhotoAlbumViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import UIKit
import Combine
import Photos
import SnapKit

class PhotoAlbumViewController: UIViewController {
    static func instance<T: PhotoAlbumViewController>(viewModel: PhotoAlbumViewModelType, dismissCompletion: ((Data?) -> Void)?) -> T {
        let vc: T = .instance(storyboardName: .photoAlbum)
        vc.viewModel = viewModel
        vc.dismissCompletion = dismissCompletion
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    enum Constants {
        static let spacing: CGFloat = 4.0
    }
    
    @IBOutlet private weak var navigationBar: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var albumTitleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private let photoAlbumListView: PhotoAlbumListView = PhotoAlbumListView()
    private var hiddenConstraint: Constraint!
    private var viewModel: PhotoAlbumViewModelType!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>? = nil
    private var cancellables: Set<AnyCancellable> = []
    var dismissCompletion: ((Data?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        bindViewModel()
    }
    
    deinit {
#if DEBUG
        print("PhotoAlbumViewController deinit")
#endif
    }
    
    // MARK: - Private
    private func setupViews() {
        view.insertSubview(photoAlbumListView, aboveSubview: collectionView)
        let albumlistViewHeight = view.height + navigationBar.height

        photoAlbumListView.snp.makeConstraints { make in
            hiddenConstraint = make.top.equalTo(navigationBar.snp.bottom).offset(-albumlistViewHeight).constraint
            make.top.equalTo(navigationBar.snp.bottom).priority(.low)
            make.height.equalTo(albumlistViewHeight)
            make.left.right.equalToSuperview()
        }
        
        hiddenConstraint.activate()
        
        photoAlbumListView.didTapSelectedAlbumInfo = { [weak self] albumInfo in
            self?.updateAlbumTitle(text: albumInfo.name)
            self?.viewModel.getPhotos(albumInfo: albumInfo)
            self?.toggleAlbumListView()
        }
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
            
            if indexPath.item > 0, let asset = self.viewModel.asset(at: indexPath.item - 1) {
                let targetSize = CGSize(width: 100, height: 100)  // 적절한 크기로 조절
                let currentIdentifier = identifier
                self.viewModel.requestImage(asset: asset, size: targetSize, contentMode: .aspectFill) { imageData in
                    if let data = imageData, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            // 현재 셀의 identifier가 요청 시작 시의 identifier와 동일한지 확인
                            if currentIdentifier == identifier {
                                cell.configure(with: image)
                            }
                        }
                    }
                }
            }
            return cell
        }
    }

    
    private func bindViewModel() {
        viewModel.photosSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                let identifiers = assets.map { $0.localIdentifier }
                self?.applySnapshot(identifiers: identifiers)
            }
            .store(in: &cancellables)
        
        viewModel.isLatestItemsButtonSelectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.arrowImageView.image = isSelected ? UIImage(named: "icArrowUp") : UIImage(named: "icArrowDown")
            }
            .store(in: &cancellables)
        
        viewModel.errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
        
        viewModel.albumInfosSubject
            .sink { [weak self] albumInfos in
                self?.updateAlbumTitle(text: albumInfos.first?.name)
            }
            .store(in: &cancellables)
        
        viewModel.photoPermissionDeniedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isDenied in
                if isDenied {
                    self?.showPermissionDeniedAlert()
                }
            }
            .store(in: &cancellables)
        
        viewModel.getAlbums(mediaType: .image)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }

    private func showPermissionDeniedAlert() {
        let alertController = UIAlertController(title: "권한 필요", message: "사진 앨범 접근 권한이 필요합니다.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func applySnapshot(identifiers: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems([""] + identifiers, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateNextButtonState() {
        if let selectedItems = collectionView.indexPathsForSelectedItems, !selectedItems.isEmpty {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    private func updateAlbumTitle(text: String?) {
        albumTitleLabel.text = text
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapColse(_ sender: UIButton) {
        self.dismissOne(amimated: true)
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        handlePhotoCropAction(captureImageData: nil) { [weak self] cropImageData in
            self?.dismiss(animated: false, completion: {
                self?.dismissCompletion?(cropImageData)
            })
        }
    }
    
    private func handlePhotoCropAction(captureImageData: Data?, completion: @escaping (Data?) -> Void) {
        viewModel.showPhotoCrop(captureImageData) { cropImageData in
            completion(cropImageData)
        }
    }
    
    @IBAction private func didTapLatestItems(_ sender: UIButton) {
        toggleAlbumListView()
    }

    private func toggleAlbumListView() {
        viewModel.toggleLatestItemsButton()
        UIView.animate(withDuration: 0.2) { [unowned self] in
            if self.hiddenConstraint.isActive {
                self.photoAlbumListView.showAlbumList(albumInfos: self.viewModel.albumInfos)
                self.hiddenConstraint.deactivate()
            } else {
                self.photoAlbumListView.showAlbumList(albumInfos: [])
                self.hiddenConstraint.activate()
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.width-6) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            viewModel.showCamera(true) { [weak self] captureImageData in
                self?.handlePhotoCropAction(captureImageData: captureImageData, completion: { cropImageData in
                    self?.dismiss(animated: false, completion: {
                        self?.dismissCompletion?(cropImageData)
                    })
                })
            }
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
                viewModel.updateSelectedAsset(indexPath.item - 1)
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
