//
//  HomeAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct HomeAPIEndpoints {
    static func getCheffiTags() -> Endpoint<[CheffiTagResponseDTO]> {
        return Endpoint(path: "tags",
                        method: .get)
    }
    
    static func getProfiles(tags: [String]) -> Endpoint<[UserResponseDTO]> {
        return Endpoint(path: "profile",
                        method: .get,
                        queryParameters: ["tags": tags]
        )
    }
}
