//
//  RatingInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

enum RatingType: String, Codable {
    case good = "GOOD"
    case average = "AVERAGE"
    case bad = "BAD"
}

// 리뷰의 타입별 총합점수
struct RatingInfoDTO: Codable {
    let ratingType: RatingType
    let rated: Bool
    
    enum CodingKeys: String, CodingKey {
        case rated
        case ratingType = "rating_type"
    }
}
