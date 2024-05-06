//
//  ProfileAPIEndpoints.swift
//  Cheffi
//
//  Created by 김문옥 on 5/6/24.
//

import Foundation

struct ProfileAPIEndpoints {
    static func getProfile(id: Int? = nil) -> Endpoint<Results<ProfileDTO>> {
        let queryParameters = id == nil ? [:] : ["id": id!]
        return Endpoint(
            path: "api/v1/profile",
            method: .get,
            headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
            queryParameters: queryParameters
        )
    }
}
