//
//  TagDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct TagDTO: Codable, Hashable {
    let id: Int
    let type: TagType
    let name: String
}

extension TagDTO {
    func toDomain() -> Tag {
        return .init(id: id, type: type, name: name)
    }
}
