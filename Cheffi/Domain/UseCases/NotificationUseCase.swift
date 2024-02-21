//
//  NotificationUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

protocol NotificationUseCase {
    func getNotifications(notificationRequest: NotificationRequest) -> AnyPublisher<[Notification], DataTransferError>
}

final class DefaultNotificationUseCase: NotificationUseCase {
    let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func getNotifications(notificationRequest: NotificationRequest) -> AnyPublisher<[Notification], DataTransferError> {
        repository.getNotifications(notificationRequest: notificationRequest)
            .map { $0.0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
