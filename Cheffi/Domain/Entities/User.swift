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
    let expired: Bool
    let nickname: String
    let userType: Provider
    let adAgreed: Bool
    let analysisAgreed: Bool
    let photoURL: String?
}

extension User {
    func updateNickname(text: String) -> User {
        return User(email: email, expired: expired, nickname: text,
                    userType: userType, adAgreed: adAgreed, analysisAgreed: analysisAgreed, photoURL: photoURL)
    }
}
