//
//  UserInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct Authority: Codable {
    let authority: String
}

struct UserDTO: Codable {
    let email: String
    let locked: Bool
    let expired: Bool
    let activated: Bool
    let nickname: String
    let name: String
    let userType: Provider
    let adAgreed: Bool
    let analysisAgreed: Bool
    let cheffiCoinCount: Int
    let pointCount: Int
    let photoURL: String?
    let isNewUser: Bool
    let profileCompleted: Bool
    let authorities: [Authority]
    
    enum CodingKeys: String, CodingKey {
        case email, expired, nickname, name, locked, activated, authorities
        case adAgreed = "ad_agreed"
        case analysisAgreed = "analysis_agreed"
        case userType = "user_type"
        case photoURL = "photo_url"
        case isNewUser = "is_new_user"
        case cheffiCoinCount = "cheffi_coin_count"
        case pointCount = "point_cnt"
        case profileCompleted = "profile_completed"
    }
}

extension UserDTO {
    func toDomain() -> User {
        return .init(email: email,
                     locked: locked,
                     expired: expired,
                     activated: activated,
                     nickname: nickname,
                     name: name,
                     userType: userType,
                     adAgreed: adAgreed,
                     analysisAgreed: analysisAgreed,
                     cheffiCoinCount: cheffiCoinCount,
                     pointCount: pointCount,
                     photoURL: photoURL,
                     isNewUser: isNewUser,
                     profileCompleted: profileCompleted)
    }
}

