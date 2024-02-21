//
//  NotificationRequest.swift
//  Cheffi
//
//  Created by ronick on 2024/02/18.
//

import Foundation

struct NotificationRequest: Encodable {
    let cursor: Int
    let size: Int
}
