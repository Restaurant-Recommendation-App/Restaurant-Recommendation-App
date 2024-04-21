//
//  TagsChangeRequest.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct TagsChangeRequest: Codable, Equatable {
    let foodTags: [Int]
    let tasteTags: [Int]
    
    enum CodingKeys: String, CodingKey {
        case foodTags = "food_tags"
        case tasteTags = "taste_tags"
    }
}

struct TestTagsChangeRequest: Codable, Equatable {
    let ids: [Int]
    let type: TagType
}
