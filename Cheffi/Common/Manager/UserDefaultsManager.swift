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
        static var tags: [String]
    }
    
    enum SearchInfo {
        @UserDefault(key: "keywords", defaultValue: [])
        static var keywords: [String]
    }
    
    enum AuthInfo {
        @UserDefault(key: "user", defaultValue: nil)
        static var user: User?
    }
}

extension UserDefaultsManager {
    static func HomeSimilarChefClear() {
        UserDefaultsManager.HomeSimilarChefInfo.tags = []
    }
    
    static func SearchClear() {
        UserDefaultsManager.SearchInfo.keywords = []
    }
    
    static func AuthClear() {
        UserDefaultsManager.AuthInfo.user = nil
    }
}
