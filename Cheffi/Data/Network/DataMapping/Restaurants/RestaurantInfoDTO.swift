//
//  RestaurantInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/22/23.
//

import Foundation

// 리뷰의 맛집 정보
struct RestaurantInfoDTO: Codable, Hashable {
    let id: Int // 식당 ID
    let name: String // 식당 이름
    let address: Address // 식당 상세주소
    let registered: Bool // 등록 여부
}
