//
//  PaginationResults.swift
//  Cheffi
//
//  Created by ronick on 2024/01/29.
//

import Foundation

struct PaginationResults<T: Decodable>: Decodable {
    let data: T
    let first: Int?
    let end: Int?
    let next: Int?
    let hasNext: Bool
    let empty: Bool
    let size: Int
    let referenceTime: String?
    let code: Int
    let message: String
}
