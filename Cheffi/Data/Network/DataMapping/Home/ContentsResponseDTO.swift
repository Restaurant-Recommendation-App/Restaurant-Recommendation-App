//
//  ContentsResponseDTO.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/20.
//

import Foundation

struct ContentsResponseDTO: Decodable {
    let page: Int
    let contents: [contentDTO]
}

extension ContentsResponseDTO {
    struct contentDTO: Decodable, Identifiable {
        typealias Identifiable = String
        
        // TODO: 서버 데이터 정해진 후 수정 필요
        var id: Identifiable = UUID().uuidString
        let title: String
        let subtitle: String
        let contentTimeLockMilliSeconds: Int
    }
}

extension ContentsResponseDTO.contentDTO {
    func toDomain() -> Content {
        .init(
            id: id,
            title: title,
            subtitle: subtitle,
            contentTimeLockSeconds: contentTimeLockMilliSeconds
        )
    }
}
