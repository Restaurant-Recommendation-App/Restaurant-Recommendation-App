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
    func getNotifications(ids: [String], deleteAll: Bool) -> AnyPublisher<[String], DataTransferError>
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
    
    func getNotifications(ids: [String], deleteAll: Bool) -> AnyPublisher<[String], DataTransferError> {
        repository.deleteNotifications(ids: ids, deleteAll: deleteAll)
            .map { $0.0.data }
            .eraseToAnyPublisher()
    }
}
