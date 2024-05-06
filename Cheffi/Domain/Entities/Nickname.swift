//
//  Nickname.swift
//  Cheffi
//
//  Created by 김문옥 on 5/11/24.
//

import Foundation

struct Nickname: Codable, Equatable {
    let value: String?
    let lastUpdatedDate: Date?
    let changeable: Bool?
}
