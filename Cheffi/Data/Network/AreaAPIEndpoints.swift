//
//  AreaAPIEndpoints.swift
//  Cheffi
//
//  Created by RONICK on 2024/01/07.
//

import Foundation

struct AreaAPIEndpoints {
    static func getAreas() -> Endpoint<Results<[AreaDTO]>> {
        return Endpoint(path: "api/v1/region",
                        method: .get)
    }
}
