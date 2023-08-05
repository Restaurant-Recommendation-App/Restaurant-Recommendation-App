//
//  CheffiTagResponseDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct CheffiTagResponseDTO: Decodable {
    let name: String
}

extension CheffiTagResponseDTO {
    func toDomain() -> CheffiTag {
        return .init(name: name)
    }
}
