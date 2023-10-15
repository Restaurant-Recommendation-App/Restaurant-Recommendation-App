//
//  User.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation

enum Provider: String, Codable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

struct User: Codable {
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
}

extension User {
    func updateNickname(text: String) -> User {
        return User(email: email,
                    locked: locked,
                    expired: expired,
                    activated: activated,
                    nickname: text,
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
