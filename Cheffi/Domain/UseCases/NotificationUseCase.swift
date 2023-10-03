//
//  NotificationUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

protocol NotificationUseCase {
    func execute() -> AnyPublisher<[Notification], DataTransferError>
}

final class DefaultNotificationUseCase: NotificationUseCase {
    let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Notification], DataTransferError> {
        repository.getNotifications()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
