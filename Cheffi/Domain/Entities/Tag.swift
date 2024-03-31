//
//  Tag.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

enum TagType: String, Codable {
    case food = "FOOD"
    case taste = "TASTE"
}

enum TagTypeRequest: String, Encodable {
    case food = "FOOD"
    case taste = "TASTE"
    case all = "ALL"
}

struct Tag: Codable, Hashable {
    var id: Int
    var type: TagType
    var name: String
}
