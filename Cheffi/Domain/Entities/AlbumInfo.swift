//
//  AlbumInfo.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import Photos

struct AlbumInfo: Identifiable, Hashable {
    let id: String?
    let name: String
    let count: Int
    let album: PHFetchResult<PHAsset>
}
