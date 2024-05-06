//
//  ProfileDTO.swift
//  Cheffi
//
//  Created by 김문옥 on 5/6/24.
//

import Foundation

struct ProfileDTO: Codable {
    let id: Int
    let nickname: NicknameDTO?
    let introduction: String?
    let photoURL: String?
    let followerCount: Int?
    let followingCount: Int?
    let post: Int?
    let cheffiCoin: Int?
    let point: Int?
    let tags: [TagDTO]
    let following: Bool?
    let blocking: Bool?
}

extension ProfileDTO {
    func toDomain() -> Profile {
        .init(
            id: id,
            nickname: nickname?.toDomain(),
            introduction: introduction,
            photoURL: photoURL,
            followerCount: followerCount,
            followingCount: followingCount,
            post: post,
            cheffiCoin: cheffiCoin,
            point: point,
            tags: tags.map { $0.toDomain() },
            following: following,
            blocking: blocking
        )
    }
}
