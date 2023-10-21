//
//  MenuDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

// 메뉴
struct MenuDTO: Codable, Hashable {
    let name: String // 메뉴 이름
    let price: Int // 메뉴 가격
    let description: String? // 메뉴 설명
}
