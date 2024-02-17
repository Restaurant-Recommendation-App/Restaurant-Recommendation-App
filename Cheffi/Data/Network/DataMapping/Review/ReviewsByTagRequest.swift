//
//  ReviewsByTagRequest.swift
//  Cheffi
//
//  Created by ronick on 2024/02/10.
//

import Foundation

struct ReviewsByTagRequest: Encodable {
    let province: String
    let city: String
    let cursor: Int
    let size: Int
    let tagId: Int
}
