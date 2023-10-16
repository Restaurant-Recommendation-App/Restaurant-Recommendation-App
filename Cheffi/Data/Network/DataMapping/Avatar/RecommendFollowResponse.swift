//
//  RecommendFollowResponse.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct RecommendFollowResponse: Codable, Hashable {
    let avatarId: Int
    let nickname: String
    let pictureUrl: String
    let followers: Int
    let tags: [TagDTO]
    
    enum CodingKeys: String, CodingKey {
        case nickname, followers, tags
        case avatarId = "avatar_id"
        case pictureUrl = "picture_url"
    }
}
