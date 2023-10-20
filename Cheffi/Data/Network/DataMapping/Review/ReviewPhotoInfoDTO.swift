//
//  ReviewPhotoInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

// 리뷰의 사진 정보
struct ReviewPhotoInfoDTO: Codable, Hashable {
    let id: Int // 리뷰 사진ID
    let order: Int // 리뷰에 보여질 사진의 순서
    let photoUrl: String? // 리뷰 사진의 URL
}
