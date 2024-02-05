//
//  ContentsResponseDTO.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/20.
//

import Foundation

struct ContentsResponseDTO: Decodable {
    typealias Identifiable = Int
    
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

extension ContentsResponseDTO {
    func toDomain() -> Content {
        .init(
            id: id,
            title: title,
            text: text,
            photo: photo,
            timeLeftToLock: timeLeftToLock,
            locked: locked,
            viewCount: viewCount,
            number: number,
            reviewStatus: reviewStatus,
            writtenByUser: writtenByUser,
            bookmarked: bookmarked,
            purchased: purchased,
            active: active)
    }
}
