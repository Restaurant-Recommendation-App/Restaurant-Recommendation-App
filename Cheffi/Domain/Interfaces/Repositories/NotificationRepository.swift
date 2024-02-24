//
//  NotificationRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

protocol NotificationRepository {
    func getNotifications(notificationRequest: NotificationRequest) -> AnyPublisher<([NotificationDTO], HTTPURLResponse), DataTransferError>
    func deleteNotifications(ids: [String], deleteAll: Bool) -> AnyPublisher<(Results<[String]>, HTTPURLResponse), DataTransferError>
}
