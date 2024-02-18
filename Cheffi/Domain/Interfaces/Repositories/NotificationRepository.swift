//
//  NotificationRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation
import Combine

protocol NotificationRepository {
    func getNotifications(cursor: Int, size: Int) -> AnyPublisher<([NotificationDTO], HTTPURLResponse), DataTransferError>
}
