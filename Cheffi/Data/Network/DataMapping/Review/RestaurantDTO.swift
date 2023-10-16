//
//  RestaurantDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

// 리뷰의 맛집 정보
struct RestaurantDTO: Codable {
    let id: Int // 식당 ID
    let name: String // 식당 이름
    let address: Address // 맛집 상세 주소
    let registered: Bool // DB 등록 여부
}
