//
//  HomeAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct HomeAPIEndpoints {
    static func getTags() -> Endpoint<[TagResponseDTO]> {
        return Endpoint(path: "tags",
                        method: .get)
    }
    
    static func getUsers(tags: [String]) -> Endpoint<[UserInfoDTO]> {
        return Endpoint(path: "users",
                        method: .get,
                        queryParameters: ["tags": tags]
        )
    }
}
