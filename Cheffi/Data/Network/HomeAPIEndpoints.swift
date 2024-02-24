//
//  HomeAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation

struct HomeAPIEndpoints {
    static func getUsers(tags: [String]) -> Endpoint<[UserDTO]> {
        return Endpoint(path: "users",
                        method: .get,
                        queryParameters: ["tags": tags]
        )
    }
    
    static func getNotifications(notificationRequest: NotificationRequest) -> Endpoint<PaginationResults<[NotificationDTO]>> {
        return Endpoint(path: "api/v1/notifications",
                        method: .get,
                        queryParametersEncodable: notificationRequest)
    }
    
    static func deleteNotifications(ids: [String], deleteAll: Bool) -> Endpoint<Results<[String]>> {
        let params: [String: Any] = ["notifications": ids,
                                     "delete_all": deleteAll]
        return Endpoint(path: "api/v1/notifications",
                        method: .delete,
                        queryParameters: params)
    }
}
