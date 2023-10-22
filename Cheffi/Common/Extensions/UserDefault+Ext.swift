//
//  UserDefault+Ext.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/28.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    private struct Wrapper<T>: Codable where T: Codable {
        let wrapped: T
    }

    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults = .standard
    
    var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) as? Data else { return defaultValue }
            
            do {
                return try JSONDecoder().decode(Wrapper<T>.self, from: value).wrapped
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        set {
            do {
                let json = try JSONEncoder().encode(Wrapper(wrapped: newValue))
                userDefaults.set(json, forKey: key)
                userDefaults.synchronize()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
