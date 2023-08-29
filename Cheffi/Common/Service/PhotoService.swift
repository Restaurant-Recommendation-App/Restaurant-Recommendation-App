//
//  PhotoService.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import Photos
import UIKit

enum MediaType {
    case all
    case image
    case video
}

final class PhotoService: NSObject {
    static let shared = PhotoService()
    weak var delegate: PHPhotoLibraryChangeObserver?
    
    override private init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    enum Constants {
        static let predicate: (MediaType) -> NSPredicate = { mediaType in
            let format = "mediaType == %d"
            switch mediaType {
            case .all:
                return .init(
                    format: format + " || " + format,
                    PHAssetMediaType.image.rawValue,
                    PHAssetMediaType.video.rawValue
                )
            case .image:
                return .init(
                    format: format,
                    PHAssetMediaType.image.rawValue
                )
            case .video:
                return .init(
                    format: format,
                    PHAssetMediaType.video.rawValue
                )
            }
        }
        static let sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false),
            NSSortDescriptor(key: "modificationDate", ascending: false)
        ]
    }
    
    let imageManager = PHCachingImageManager()
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
        var allAlbums = [AlbumInfo]()
        
        let fetchAssetOptions = PHFetchOptions()
        fetchAssetOptions.predicate = Constants.predicate(mediaType)
        fetchAssetOptions.sortDescriptors = Constants.sortDescriptors
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        
        smartAlbums.enumerateObjects { (collection, _, stop) in
            let assets = PHAsset.fetchAssets(in: collection, options: fetchAssetOptions)
            
            if assets.count > 0 {
                allAlbums.append(
                    .init(
                        id: collection.localIdentifier,
                        name: collection.localizedTitle ?? "",
                        count: assets.count,
                        album: assets
                    )
                )
            }
        }
        
        completion(allAlbums)
    }
    
    func getPHAssets(album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void) {
        var phAssets = [PHAsset]()
        
        album.enumerateObjects { asset, _, _ in
            phAssets.append(asset)
        }
        
        completion(phAssets)
    }
    
    func requestImage(
        for asset: PHAsset,
        targetSize size: CGSize,
        contentMode: PHImageContentMode,
        completion: @escaping (UIImage?) -> Void
    ) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        self.imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: options
        ) { image, _ in
            completion(image)
        }
    }
}

extension PhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.photoLibraryDidChange(changeInstance)
    }
}
