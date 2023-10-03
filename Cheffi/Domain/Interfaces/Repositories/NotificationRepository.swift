//
//  NotificationRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

protocol NotificationRepository {
    func getNotifications() -> AnyPublisher<[NotificationDTO], DataTransferError>
}
