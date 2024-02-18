//
//  NotificationDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation

struct NotificationDTO: Codable {
    let id: String
    let cateogry: NotificationType
    let content: String
    let checked: Bool
    let notifiedDate: String
}

extension NotificationDTO {
    func toDomain() -> Notification {
        return .init(id: id,
                     category: cateogry,
                     content: content,
                     checked: checked,
                     notifiedDate: notifiedDate)
    }
}
