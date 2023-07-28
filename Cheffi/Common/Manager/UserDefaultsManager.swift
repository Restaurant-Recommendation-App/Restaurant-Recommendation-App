//
//  UserDefaultsManager.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation

enum UserDefaultsManager {
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
    static func AuthClear() {
        UserDefaultsManager.AuthInfo.user = nil
    }
    
    static func SearchClear() {
        UserDefaultsManager.SearchInfo.keywords = []
    }
}
