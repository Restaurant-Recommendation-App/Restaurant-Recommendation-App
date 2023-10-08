//
//  Notification.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Foundation

enum NotificationType: String, Codable {
    case follow = "FOLLOW"
    case like = "LIKE"
    case notice = "NOTICE"
    case post = "POST"
    
    var title: String {
        switch self {
        case .follow: return "팔로우"
        case .like: return "찜"
        case .notice: return "공식 게시글"
        case .post: return "게시글"
        }
    }
    
    var imageName: String {
        switch self {
        case .follow: return "icNotificationFollow"
        case .like: return "icNotificationLike"
        case .notice: return "icNotificationNotice"
        case .post: return "icNotificationPost"
        }
    }
}

struct Notification: Codable {
    let id: String
    let notificationType: NotificationType
    let content: String
}
