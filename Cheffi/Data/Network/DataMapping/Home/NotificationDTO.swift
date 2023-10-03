//
//  NotificationDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation

struct NotificationDTO: Codable {
    let notificatioType: NotificationType
    let content: String
}

extension NotificationDTO {
    func toDomain() -> Notification {
        return .init(notificationType: notificatioType,
                     content: content)
    }
}
