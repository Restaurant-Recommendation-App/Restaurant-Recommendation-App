//
//  UserDefaultsManager.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation

enum UserDefaultsManager {
    enum HomeSimilarChefInfo {
        @UserDefault(key: "tags", defaultValue: [])
        static var tags: [Tag]
    }
    
    enum SearchInfo {
        @UserDefault(key: "keywords", defaultValue: [])
        static var keywords: [String]
    }
    
    enum UserInfo {
        @UserDefault(key: "userInfo", defaultValue: nil)
        static var user: User?
    }
    
    enum AuthInfo {
        @UserDefault(key: "authInfo", defaultValue: nil)
        static var sessionToken: String?
    }
    
    enum NotificationInfo {
        @UserDefault(key: "notificationIds", defaultValue: [])
        static var notificationIds: [String]
    }
}

extension UserDefaultsManager {
    static func HomeSimilarChefClear() {
        UserDefaultsManager.HomeSimilarChefInfo.tags = []
    }
    
    static func SearchClear() {
        UserDefaultsManager.SearchInfo.keywords = []
    }
    
    static func UserClear() {
        UserDefaultsManager.UserInfo.user = nil
    }
    
    static func AuthClear() {
        UserDefaultsManager.AuthInfo.sessionToken = nil
    }
    
    static func NotificationClear() {
        UserDefaultsManager.NotificationInfo.notificationIds = []
    }
}
