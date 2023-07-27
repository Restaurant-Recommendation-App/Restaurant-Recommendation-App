//
//  UserDefaultsManager.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation

final class UserDefaultsManager: NSObject {
    static let standard = UserDefaults.standard
}

extension UserDefaultsManager {
    enum KeyConstant: String, CaseIterable {
        case searchKeyword
    }
    
    enum AuthInfo: String, CaseIterable {
        case user
    }
    
    static var user: User? {
        get { return loadObject(key: AuthInfo.user.rawValue) }
        set { saveObject(newValue, key: AuthInfo.user.rawValue) }
    }
    
    static func clear() {
        KeyConstant.allCases.map { $0.rawValue }.forEach { (key) in
            standard.set(nil, forKey: key)
        }
        standard.synchronize()
    }
    
    static var searchKeyword: [String] {
        get { return structArrayData(String.self, forKey: KeyConstant.searchKeyword.rawValue) }
        set { setStructArray(newValue, forKey: KeyConstant.searchKeyword.rawValue) }
    }
}

extension UserDefaultsManager {
    static func loadObject<T: Decodable>(key: String) -> T? {
        if let savedData = standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(T.self, from: savedData) {
                return loadedData
            }
        }
        return nil
    }
    
    static func saveObject<T: Encodable>(_ newValue: T?, key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newValue) {
            standard.set(encoded, forKey: key)
        } else {
            standard.set(nil, forKey: key)
        }
        
        standard.synchronize()
    }
    
    static func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String) {
        let data = value.map { try? JSONEncoder().encode($0) }
        standard.set(data, forKey: defaultName)
        standard.synchronize()
    }
    
    static func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T: Decodable {
        guard let encodedData = standard.array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.compactMap { try? JSONDecoder().decode(type, from: $0) }
    }
}

extension UserDefaults {
    subscript<T, K>(key: K) -> T? where K: RawRepresentable, K.RawValue == String {
        get { return object(forKey: key.rawValue) as? T }
        set { set(newValue, forKey: key.rawValue) }
    }
}
