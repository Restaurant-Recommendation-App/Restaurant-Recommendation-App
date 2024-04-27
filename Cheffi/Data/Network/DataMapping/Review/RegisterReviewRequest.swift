//
//  RegisterReviewRequest.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

struct RegisterReviewRequest: Codable, Equatable {
    let restaurantId: Int
    let registered: Bool
    let title: String
    let text: String
    let menus: [MenuDTO]
    let tags: TagsChangeRequest
    private var encodedTags: [TagDTO] {
        let foodTagsDTO = tags.foodTags.map { TagDTO(id: $0, type: .food, name: "") }
        let tasteTagsDTO = tags.tasteTags.map { TagDTO(id: $0, type: .taste, name: "") }
        return foodTagsDTO + tasteTagsDTO
    }
    
    
    enum CodingKeys: String, CodingKey {
        case restaurantId = "restaurant_id"
        case registered, title, text, menus, tags
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.restaurantId, forKey: .restaurantId)
        try container.encode(self.registered, forKey: .registered)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.menus, forKey: .menus)
        try container.encode(self.encodedTags, forKey: .tags)
    }
}
