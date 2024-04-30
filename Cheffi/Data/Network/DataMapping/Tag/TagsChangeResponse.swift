//
//  TagsChangeResponse.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct TagsChangeResponse: Codable {
    let tags: [TagDTO]
    let type: TagType
}
