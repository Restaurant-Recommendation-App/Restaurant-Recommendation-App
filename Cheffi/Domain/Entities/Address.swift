//
//  Address.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

// 맛집 상세 주소
struct Address: Codable, Hashable {
    let province: String // 식당의 시/도 주소(1차)
    let city: String // 식당의 시/군/구 주소(2차)
    let lotNumber: String // 지번 주소
    let roadName: String // 도로명 주소
    let fullLotNumberAddress: String // 식당 전체 지번 주소
    let fullRodNameAddress: String // 식당 전체 도로명 주소
    
    enum CodingKeys: String, CodingKey {
        case province, city
        case lotNumber = "lot_number"
        case roadName = "road_name"
        case fullLotNumberAddress = "full_lot_number_address"
        case fullRodNameAddress = "full_rod_name_address"
    }
}
