//
//  ReviewInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

// 리뷰 정보
struct ReviewInfoDTO: Codable {
    let id: Int // 리뷰 ID
    let title: String // 리뷰 제목
    let text: String // 리뷰의 적힌 본문 내용
    let ratingCount: Int // 리뷰의 평가 총합 점수
    let bookmarked: Bool // 북마크 여부
    
    enum CodingKeys: String, CodingKey {
        case id, title, text, bookmarked
        case ratingCount = "rating_cnt"
    }
}
