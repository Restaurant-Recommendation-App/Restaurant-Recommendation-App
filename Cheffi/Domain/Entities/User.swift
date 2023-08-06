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
    let name: String
    let provider: Provider
    let adAgreed: Bool
    let analysisAgreed: Bool
}
