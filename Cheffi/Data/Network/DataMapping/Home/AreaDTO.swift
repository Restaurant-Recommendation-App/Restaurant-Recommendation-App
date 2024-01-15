//
//  AreaDTO.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/23.
//

import Foundation

struct AreaDTO: Codable {
    let province: String
    let cities: [String]
}

extension AreaDTO {
    func toDomain() -> Area {
        Area(province: self.province, cities: self.cities)
    }
}
