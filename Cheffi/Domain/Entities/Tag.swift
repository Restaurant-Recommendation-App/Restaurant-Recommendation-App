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

struct Tag: Codable {
    var id: Int64
    var tagType: TagType
    var name: String
}
