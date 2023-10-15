//
//  TagsChangeResponse.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct TagsChangeResponse: Codable {
    let foodTags: [TagDTO]
    let tasteTags: [TagDTO]
    
    enum CodingKeys: String, CodingKey {
        case foodTags = "food_tags"
        case tasteTags = "taste_tags"
    }
}
