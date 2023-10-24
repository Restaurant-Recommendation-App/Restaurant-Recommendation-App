//
//  AreaDTO.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/23.
//

import Foundation

struct AreaDTO: Decodable {
    let si: String
    let gu: [String]
}


extension AreaDTO {
    func toDomain() -> Area {
        Area(si: self.si, gu: self.gu)
    }
}
