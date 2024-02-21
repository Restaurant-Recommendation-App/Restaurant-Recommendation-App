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
    
    static func getNotifications(notificationRequest: NotificationRequest) -> Endpoint<[NotificationDTO]> {
        return Endpoint(path: "api/v1/notifications",
                        method: .get,
                        queryParametersEncodable: notificationRequest)
    }
}
