//
//  PhotoAlbumViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/11.
//

import Foundation
import Combine
import Photos

struct CapturedImage {
    let imageData: Data
}

protocol PhotoAlbumViewModelInput {
    func getAlbums(mediaType: MediaType)
    func getPhotos(albumInfo: AlbumInfo)
    func requestImage(asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void)
    func toggleLatestItemsButton()
    func captureCameraImage()
}

protocol PhotoAlbumViewModelOutput {
    var isLatestItemsButtonSelectedPublisher: Published<Bool>.Publisher { get }
    var errorSubject: PassthroughSubject<String, Never> { get }
    var downloadingAssetsPublisher: Published<Set<String>>.Publisher { get }
    var capturedImagePublisher: AnyPublisher<CapturedImage?, Never> { get }
    var albumInfosSubject: PassthroughSubject<[AlbumInfo], Never> { get }
    var photosSubject: PassthroughSubject<[PHAsset], Never> { get }
    func asset(at index: Int) -> PHAsset?
    var photoPermissionDeniedPublisher: Published<Bool>.Publisher { get }
}

typealias PhotoAlbumViewModelType = PhotoAlbumViewModelInput & PhotoAlbumViewModelOutput

class PhotoAlbumViewModel: PhotoAlbumViewModelType {
    private let photoUseCase: PhotoUseCase
    private let cameraService: CameraService
    private var cancellables: Set<AnyCancellable> = []
    private var capturedImageSubject = PassthroughSubject<CapturedImage?, Never>()
    private var currentAssets: [PHAsset] = []
    @Published private(set) var isLatestItemsButtonSelected: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var downloadingAssets: Set<String> = []
    @Published private(set) var capturedImage: CapturedImage? = nil
    @Published private(set) var photoPermissionDenied: Bool = false
    
    // MARK: - Input
    func getAlbums(mediaType: MediaType) {
        photoUseCase.getAlbums(for: mediaType) { [weak self] albumInfos in
            DispatchQueue.main.async {
                self?.albumInfosSubject.send(albumInfos)
                if let albumInfo = albumInfos.first {
                    self?.getPhotos(albumInfo: albumInfo)
                }
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
    
    func captureCameraImage() {
        cameraService.captureImage()
            .sink { [weak self] capturedImageData in
                guard let data = capturedImageData?.imageData else { return }
                let capturedImage = CapturedImage(imageData: data)
                self?.capturedImage = capturedImage
                self?.capturedImageSubject.send(capturedImage)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Output
    var isLatestItemsButtonSelectedPublisher: Published<Bool>.Publisher { $isLatestItemsButtonSelected }
    var errorSubject = PassthroughSubject<String, Never>()
    var downloadingAssetsPublisher: Published<Set<String>>.Publisher { $downloadingAssets }
    var capturedImagePublisher: AnyPublisher<CapturedImage?, Never> { capturedImageSubject.eraseToAnyPublisher() }
    var albumInfosSubject = PassthroughSubject<[AlbumInfo], Never>()
    var photosSubject = PassthroughSubject<[PHAsset], Never>()
    var photoPermissionDeniedPublisher: Published<Bool>.Publisher { $photoPermissionDenied }
    
    func asset(at index: Int) -> PHAsset? {
        guard index < currentAssets.count else { return nil }
        return currentAssets[index]
    }
    
    func checkPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .denied, .restricted:
            photoPermissionDenied = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                if newStatus == .denied || newStatus == .restricted {
                    DispatchQueue.main.async {
                        self?.photoPermissionDenied = true
                    }
                }
            }
        default:
            break
        }
    }
    
    init(photoUseCase: PhotoUseCase, cameraService: CameraService) {
        self.photoUseCase = photoUseCase
        self.cameraService = cameraService
        
        checkPhotoPermission()
    }
}

