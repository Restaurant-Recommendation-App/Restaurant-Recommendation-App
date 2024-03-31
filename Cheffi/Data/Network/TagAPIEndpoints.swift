//
//  TagAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct TagAPIEndpoints {
    static func getTags(type: TagTypeRequest) -> Endpoint<Results<[TagDTO]>> {
        Endpoint(
            path: "api/v1/tags",
            method: .get,
            queryParameters: ["type": type.rawValue]
        )
    }
    
    static func putTags(tagRequest: TagsChangeRequest) -> Endpoint<Results<TagsChangeResponse>> {
        Endpoint(
            path: "api/v1/avatars/tags",
            method: .put,
            headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
            bodyParametersEncodable: tagRequest
        )
    }
}
