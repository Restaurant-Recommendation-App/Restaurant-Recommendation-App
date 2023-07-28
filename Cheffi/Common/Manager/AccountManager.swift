//
//  AccountManager.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/28.
//

import Foundation

class AccountManager: NSObject {
    static var shared: AccountManager = AccountManager()
    
    var isLogin: Bool {
        return UserDefaultsManager.AuthInfo.user != nil
    }
}
