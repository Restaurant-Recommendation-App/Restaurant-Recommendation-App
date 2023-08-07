//
//  UserInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct UserInfoDTO: Codable {
    let email: String
    let name: String
    let provider: Provider
    let adAgreed: Bool
    let analysisAgreed: Bool
}

extension UserInfoDTO {
    func toDomain() -> User {
        return .init(email: email, name: name, provider: provider, adAgreed: adAgreed, analysisAgreed: analysisAgreed)
    }
}

