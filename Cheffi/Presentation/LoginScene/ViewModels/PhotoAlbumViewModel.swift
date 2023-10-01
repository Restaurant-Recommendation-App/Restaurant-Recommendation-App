//
//  PhotoAlbumViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/11.
//

import Foundation
import Combine
import Photos

struct PhotoAlbumViewModelActions {
    let showPhotoCrop: (_ imageData: Data, _ dismissCompletion: ((Data?) -> Void)?) -> Void
    let showCamera: (_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?) -> Void
}

struct CapturedImage {
    let imageData: Data
}

protocol PhotoAlbumViewModelInput {
    func getAlbums(mediaType: MediaType)
    func getPhotos(albumInfo: AlbumInfo)
    func requestImage(asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void)
    func toggleLatestItemsButton()
    func updateSelectedAsset(_ index: Int)
    func showPhotoCrop(_ captureImageData: Data?, _ dismissCompletion: ((Data?) -> Void)?)
    func showCamera(_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?)
}

protocol PhotoAlbumViewModelOutput {
    var isLatestItemsButtonSelectedPublisher: Published<Bool>.Publisher { get }
    var errorSubject: PassthroughSubject<String, Never> { get }
    var downloadingAssetsPublisher: Published<Set<String>>.Publisher { get }
    var albumInfosSubject: PassthroughSubject<[AlbumInfo], Never> { get }
    var photosSubject: PassthroughSubject<[PHAsset], Never> { get }
    func asset(at index: Int) -> PHAsset?
    var selectedAsset: PHAsset? { get }
    var photoPermissionDeniedPublisher: Published<Bool>.Publisher { get }
    var albumInfos: [AlbumInfo] { get }
}

typealias PhotoAlbumViewModelType = PhotoAlbumViewModelInput & PhotoAlbumViewModelOutput

class PhotoAlbumViewModel: PhotoAlbumViewModelType {
    private let actions: PhotoAlbumViewModelActions
    private let photoUseCase: PhotoUseCase
    private let cameraService: CameraService
    private var cancellables: Set<AnyCancellable> = []
    private var currentAssets: [PHAsset] = []
    private var _selectedAsset: PHAsset? = nil
    private(set) var albumInfos: [AlbumInfo] = []
    @Published private(set) var isLatestItemsButtonSelected: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var downloadingAssets: Set<String> = []
    @Published private(set) var capturedImage: CapturedImage? = nil
    @Published private(set) var photoPermissionDenied: Bool = false
    
    // MARK: - Input
    func getAlbums(mediaType: MediaType) {
        photoUseCase.getAlbums(for: mediaType) { [weak self] albumInfos in
            self?.albumInfos = albumInfos
            self?.albumInfosSubject.send(albumInfos)
            if let albumInfo = albumInfos.first {
                self?.getPhotos(albumInfo: albumInfo)
            }
        }
    }
    
    func getPhotos(albumInfo: AlbumInfo) {
        photoUseCase.getPhotos(in: albumInfo) { [weak self] assets in
            self?.currentAssets = assets
            self?.photosSubject.send(assets)
        }
    }
    
    func requestImage(asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void) {
        photoUseCase.requestImage(for: asset, size: size, contentMode: contentMode, completion: completion)
    }
    
    func toggleLatestItemsButton() {
        isLatestItemsButtonSelected.toggle()
    }
    
    func updateSelectedAsset(_ index: Int) {
        guard index < currentAssets.count else { return }
        _selectedAsset = currentAssets[index]
    }
    
    func showCamera(_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?) {
        actions.showCamera(isPresentPhotoAlbum, dismissCompletion)
    }
    
    func showPhotoCrop(_ captureImageData: Data?, _ dismissCompletion: ((Data?) -> Void)?) {
        if let imageData = captureImageData {
            self.actions.showPhotoCrop(imageData, dismissCompletion)
            return
        }
        
        guard let selectedAsset = self._selectedAsset else {
            self.errorSubject.send("선택 된 이미지가 없습니다.")
            return
        }
        
        requestImage(asset: selectedAsset, size: CGSize(width: 1024, height: 1024), contentMode: .default) { [weak self] imageData in
            if let data = imageData {
                self?.actions.showPhotoCrop(data, dismissCompletion)
            } else {
                self?.errorSubject.send("이미지를 불러오는 도중 실패 했습니다.")
            }
        }
    }
    
    // MARK: - Output
    var isLatestItemsButtonSelectedPublisher: Published<Bool>.Publisher { $isLatestItemsButtonSelected }
    var errorSubject = PassthroughSubject<String, Never>()
    var downloadingAssetsPublisher: Published<Set<String>>.Publisher { $downloadingAssets }
    var albumInfosSubject = PassthroughSubject<[AlbumInfo], Never>()
    var photosSubject = PassthroughSubject<[PHAsset], Never>()
    var photoPermissionDeniedPublisher: Published<Bool>.Publisher { $photoPermissionDenied }
    var selectedAsset: PHAsset? { _selectedAsset }
    
    func asset(at index: Int) -> PHAsset? {
        guard index < currentAssets.count else { return nil }
        return currentAssets[index]
    }
    
    func checkPhotoPermission(completion: ((Bool) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .denied, .restricted:
            photoPermissionDenied = true
            completion?(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                switch newStatus {
                case .denied, .restricted:
                    self?.photoPermissionDenied = true
                    completion?(false)
                case .authorized:
                    completion?(true)
                default:
                    completion?(false)
                }
            }
        case .authorized:
            completion?(true)
        default:
            completion?(false)
        }
    }
    
    // MARK: - Init
    init(actions: PhotoAlbumViewModelActions, photoUseCase: PhotoUseCase, cameraService: CameraService) {
        self.actions = actions
        self.photoUseCase = photoUseCase
        self.cameraService = cameraService
        
        checkPhotoPermission(completion: nil)
    }
}

