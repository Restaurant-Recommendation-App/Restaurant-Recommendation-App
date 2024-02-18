//
//  NotificationUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

protocol NotificationUseCase {
    func getNotifications(cursor: Int, size: Int) -> AnyPublisher<[Notification], DataTransferError>
}

final class DefaultNotificationUseCase: NotificationUseCase {
    let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func getNotifications(cursor: Int, size: Int) -> AnyPublisher<[Notification], DataTransferError> {
        repository.getNotifications(cursor: cursor, size: size)
            .map { $0.0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
