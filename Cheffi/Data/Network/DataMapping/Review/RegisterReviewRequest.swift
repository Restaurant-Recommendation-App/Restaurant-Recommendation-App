//
//  RegisterReviewRequest.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

struct RegisterReviewRequest: Codable {
    let restaurantId: Int
    let registered: Bool
    let title: String
    let text: String
    let menus: [MenuDTO]
    let tag: TagsChangeRequest
    
    enum CodingKeys: String, CodingKey {
        case restaurantId = "restaurant_id"
        case registered, title, text, menus, tag
    }
}
