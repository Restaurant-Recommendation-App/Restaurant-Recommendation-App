//
//  Content.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/20.
//

import Foundation

struct Content: Decodable, Identifiable {
    typealias Identifier = Int
    
    let id: Int
    let title: String
    let text: String
    let photo: PhotoInfoDTO
    let timeLeftToLock: Int
    let locked: Bool
    let viewCount: Int
    let number: Int
    let reviewStatus: String
    let writtenByUser: Bool
    let bookmarked: Bool
    let purchased: Bool
    let active: Bool
}
