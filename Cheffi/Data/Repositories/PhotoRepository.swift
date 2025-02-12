//
//  PhotoRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import Photos
import Combine

protocol PhotoRepository {
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void)
    func getPhotos(in album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void)
    func requestImage(for asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void)
    func requestImages(for assets: [PHAsset], size: CGSize, contentMode: PHImageContentMode) async -> [Data?]
    func postPhotos(imageData: Data, changeProfilePhotoRequest: ChangeProfilePhotoRequest) -> AnyPublisher<(Results<String>, HTTPURLResponse), DataTransferError>
}

class DefaultPhotoRepository: PhotoRepository {
    private let service = PhotoService.shared
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
    
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
        service.getAlbums(mediaType: mediaType, completion: completion)
    }
    
    func getPhotos(in album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void) {
        service.getPHAssets(album: album, completion: completion)
    }
    
    func requestImage(for asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void) {
        service.requestImage(for: asset, targetSize: size, contentMode: contentMode) { image in
            let data = image?.pngData()
            completion(data)
        }
    }
    
    func requestImages(for assets: [PHAsset], size: CGSize, contentMode: PHImageContentMode) async -> [Data?] {
        var imageDataArray: [Data] = []
        
        for asset in assets {
            let imageData = await withCheckedContinuation { continuation in
                service.requestImage(for: asset, targetSize: size, contentMode: contentMode) { image in
                    continuation.resume(returning: image?.pngData())
                }
            }
            if let imageData {
                imageDataArray.append(imageData)
            }
        }
        
        return imageDataArray
    }
    
    // 프로필 사진 변경
    func postPhotos(imageData: Data, changeProfilePhotoRequest: ChangeProfilePhotoRequest) -> AnyPublisher<(Results<String>, HTTPURLResponse), DataTransferError> {
        let endpoint = AuthAPIEndpoints.postPhosts(imageData: imageData, changeProfilePhotoRequest: changeProfilePhotoRequest)
        return dataTransferService.request(with: endpoint, on: backgroundQueue).eraseToAnyPublisher()
    }
}

