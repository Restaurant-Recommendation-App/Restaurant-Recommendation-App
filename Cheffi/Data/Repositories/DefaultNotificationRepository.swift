//
//  DefaultNotificationRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

final class DefaultNotificationRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DispatchQueue
    
    init(dataTransferService: DataTransferService,
         backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultNotificationRepository: NotificationRepository {
    func getNotifications(notificationRequest: NotificationRequest) -> AnyPublisher<(PaginationResults<[NotificationDTO]>, HTTPURLResponse), DataTransferError> {
        let endpoint = HomeAPIEndpoints.getNotifications(notificationRequest: notificationRequest)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
    
    func deleteNotifications(ids: [String], deleteAll: Bool) -> AnyPublisher<(Results<[String]>, HTTPURLResponse), DataTransferError> {
        let endpoint = HomeAPIEndpoints.deleteNotifications(ids: ids, deleteAll: deleteAll)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
}
