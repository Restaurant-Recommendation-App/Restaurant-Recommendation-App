//
//  AvatarInfoResponse.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct AvatarInfoResponse: Codable {
    let id: Int
    let nickname: String
    let pictureUrl: String
    let introduction: String?
    let follower: Int
    let following: Int
    let post: Int
    let tagDtos: [TagDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, nickname, introduction, follower, following, post
        case pictureUrl = "picture_url"
        case tagDtos = "tag_dtos"
    }
}
