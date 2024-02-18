//
//  Notification.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation

enum NotificationType: String, Codable {
    case review = "REVIEW"
    case bookmark = "BOOKMARK"
    case follow = "FOLLOW"
    case official = "OFFICIAL"
    
    var title: String {
        switch self {
        case .review: return "게시글"
        case .bookmark: return "찜"
        case .follow: return "팔로우"
        case .official: return "공식 게시글"
        }
    }
    
    var imageName: String {
        switch self {
        case .review: return "icNotificationPost"
        case .bookmark: return "icNotificationLike"
        case .follow: return "icNotificationFollow"
        case .official: return "icNotificationNotice"
        }
    }
}

struct Notification: Codable {
    let id: String
    let notificationType: NotificationType
    let content: String
}
