//
//  ReviewPhotoInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

// 리뷰의 맛집 정보
struct ReviewPhotoInfoDTO: Codable {
    let id: Int // 리뷰 사진ID
    let photoOrderInReview: Int // 리뷰에 보여질 사진의 순서
    let reviewUrl: String? // 리뷰 사진의 URL
}
