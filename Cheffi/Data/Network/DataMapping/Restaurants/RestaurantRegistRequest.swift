//
//  RestaurantRegistRequest.swift
//  Cheffi
//
//  Created by 김문옥 on 3/10/24.
//

import Foundation

/// 맛집 정보 등록 요청을 위한 정보
struct RestaurantRegistRequest: Codable {
    let name: String
    let detailedAddress: Address
}
