//
//  TagResponseDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct TagResponseDTO: Codable {
    let id: Int64
    let tagType: TagType
    let name: String
}

extension TagResponseDTO {
    func toDomain() -> Tag {
        return .init(id: id, tagType: tagType, name: name)
    }
}
