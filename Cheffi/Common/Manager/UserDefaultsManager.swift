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
        static var notificationIds: [Int]
    }
        
    enum AreaInfo {
        //TODO: 아무지역도 선택하지 않았을 시 기본 선택값 설정 필요
        @UserDefault(key: "area", defaultValue: CityInfo(province: "서울특별시", city: "강남구"))
        static var area: CityInfo
    }
    
    enum Understanding {
        @UserDefault(key: "reviewCanBeDeleted", defaultValue: false)
        static var reviewCanBeDeleted: Bool
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
    
    static func AreaClear() {
        //TODO: 아무지역도 선택하지 않았을 시 기본 선택값 설정 필요
        UserDefaultsManager.AreaInfo.area = CityInfo(province: "서울특별시", city: "강남구")
    }
}
