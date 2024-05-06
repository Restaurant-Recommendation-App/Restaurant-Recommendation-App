//
//  Profile.swift
//  Cheffi
//
//  Created by 김문옥 on 5/6/24.
//

import Foundation

struct Profile: Codable, Equatable {
    let id: Int
    let nickname: Nickname?
    let introduction: String?
    let photoURL: String?
    let followerCount: Int?
    let followingCount: Int?
    let post: Int?
    let cheffiCoin: Int?
    let point: Int?
    let tags: [Tag]
    let following: Bool?
    let blocking: Bool?
}
