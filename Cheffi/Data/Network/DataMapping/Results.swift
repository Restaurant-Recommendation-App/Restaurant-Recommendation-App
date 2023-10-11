//
//  Results.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation

struct Results<T: Codable>: Codable {
    let data: T
    let code: Int
    let message: String
}
