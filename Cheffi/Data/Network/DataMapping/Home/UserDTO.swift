//
//  UserInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct UserDTO: Codable {
    let email: String
    let expired: Bool
    let nickname: String
    let userType: Provider
    let adAgreed: Bool
    let analysisAgreed: Bool
    let photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case email, expired, nickname
        case adAgreed = "ad_agreed"
        case analysisAgreed = "analysis_agreed"
        case userType = "user_type"
        case photoURL = "photo_url"
    }
}

extension UserDTO {
    func toDomain() -> User {
        return .init(email: email,
                     expired: expired,
                     nickname: nickname,
                     userType: userType,
                     adAgreed: adAgreed,
                     analysisAgreed: analysisAgreed,
                     photoURL: photoURL)
    }
}

