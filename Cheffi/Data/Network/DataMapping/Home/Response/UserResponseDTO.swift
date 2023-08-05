//
//  UserResponseDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct UserResponseDTO: Decodable {
    let id: Int
    let name: String
}

extension UserResponseDTO {
    func toDomain() -> User {
        return .init(id: id,
                     name: name)
    }
}
