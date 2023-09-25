//
//  Content.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/20.
//

import Foundation

struct Content: Decodable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String
    let subtitle: String
    let contentTimeLockSeconds: Int
}
