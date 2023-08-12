//
//  DefaultFetchPhotoUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import Foundation
import Combine
import Photos

protocol FetchPhotoUseCase {
    func fetchPhotoIdentifiers() -> Future<(photoIdentifiers: [String], downloadingIdentifiers: Set<String>), Error>
}

final class DefaultFetchPhotoUseCase: FetchPhotoUseCase {
    
    func fetchPhotoIdentifiers() -> Future<(photoIdentifiers: [String], downloadingIdentifiers: Set<String>), Error> {
        return Future { promise in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                // 권한 요청이 아직 결정되지 않았을 때
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        if newStatus == .authorized {
                            self.performPhotoFetch(promise: promise)
                        } else {
                            promise(.failure(NSError(domain: "PhotoPermissionError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Photo library access is denied"])))
                        }
                    }
                }
            case .authorized:
                // 권한이 이미 허용됐을 때
                self.performPhotoFetch(promise: promise)
            default:
                promise(.failure(NSError(domain: "PhotoPermissionError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Photo library access is denied"])))
            }
        }
    }

    private func performPhotoFetch(promise: @escaping (Result<(photoIdentifiers: [String], downloadingIdentifiers: Set<String>), Error>) -> Void) {
        var photoIdentifiers: [String] = []
        var downloadingIdentifiers: Set<String> = []
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true  // iCloud에서 이미지 다운로드 허용
        
        fetchResult.enumerateObjects { (asset, _, _) in
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) { (image, info) in
                // 에러 처리
                if let error = info?[PHImageErrorKey] as? Error {
                    promise(.failure(error))
                    return
                }
                
                if let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool, isDegraded {
                    // 저해상도 이미지 반환됨 (다운로드 중)
                    downloadingIdentifiers.insert(asset.localIdentifier)
                    return
                }
                
                if let image = image, let data = image.pngData() {
                    let identifier = data.base64EncodedString(options: .lineLength64Characters)
                    photoIdentifiers.append(identifier)
                }
            }
        }
        
        promise(.success((photoIdentifiers: photoIdentifiers, downloadingIdentifiers: downloadingIdentifiers)))
    }
}

