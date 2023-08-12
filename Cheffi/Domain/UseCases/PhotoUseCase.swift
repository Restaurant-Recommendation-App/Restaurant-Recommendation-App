//
//  PhotoUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import Combine
import Photos

protocol PhotoUseCase {
    func getAlbums(for mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void)
    func getPhotos(in albumInfo: AlbumInfo, completion: @escaping ([PHAsset]) -> Void)
    func requestImage(for asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void)
}

final class DefaultPhotoUseCase: PhotoUseCase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func getAlbums(for mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
        repository.getAlbums(mediaType: mediaType, completion: completion)
    }
    
    func getPhotos(in albumInfo: AlbumInfo, completion: @escaping ([PHAsset]) -> Void) {
        repository.getPhotos(in: albumInfo.album, completion: completion)
    }
    
    func requestImage(for asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void) {
        repository.requestImage(for: asset, size: size, contentMode: contentMode, completion: completion)
    }
}
