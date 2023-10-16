//
//  FollowResponse.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct FollowResponse: Codable {
    let followerId: Int?
    let followeeId: Int?
    let avatarId: String?
    let nickname: String?
    
    enum CodingKeys: String, CodingKey {
        case followerId = "follower_id"
        case followeeId = "followee_id"
        case avatarId = "avatar_id"
        case nickname
    }
}
