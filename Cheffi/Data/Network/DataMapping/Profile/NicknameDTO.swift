//
//  NicknameDTO.swift
//  Cheffi
//
//  Created by 김문옥 on 5/11/24.
//

import Foundation

struct NicknameDTO: Codable {
    let value: String?
    let lastUpdateDate: Date?
    let changeable: Bool?
}

extension NicknameDTO {
    func toDomain() -> Nickname {
        Nickname(
            value: value,
            lastUpdatedDate: lastUpdateDate,
            changeable: changeable
        )
    }
}
