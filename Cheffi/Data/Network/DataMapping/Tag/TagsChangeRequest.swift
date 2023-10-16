//
//  TagsChangeRequest.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct TagsChangeRequest: Codable {
    let foodTags: [Int]
    let tasteTags: [Int]
    
    enum CodingKeys: String, CodingKey {
        case foodTags = "food_tags"
        case tasteTags = "taste_tags"
    }
}
