//
//  PhotoRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import Photos

protocol PhotoRepository {
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void)
    func getPhotos(in album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void)
    func requestImage(for asset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (Data?) -> Void)
}

class DefaultPhotoRepository: PhotoRepository {
    private let service = PhotoService.shared
    
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
}

