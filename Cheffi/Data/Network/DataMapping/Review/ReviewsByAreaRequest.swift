//
//  ReviewsByAreaRequest.swift
//  Cheffi
//
//  Created by ronick on 2024/01/30.
//

import Foundation

struct ReviewsByAreaRequest: Encodable {
    let province: String
    let city: String
    let cursor: Int
    let size: Int
}
