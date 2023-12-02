//
//  UserDefaults.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value?
    
    init(key: String, defaultValue: Value? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}

extension UserDefaults {
    @UserDefault(key: Constants.UserDefaultsKeys.tokenKey, defaultValue: nil)
    public static var accessTokenKey: String?
    
    @UserDefault(key: Constants.UserDefaultsKeys.userID, defaultValue: nil)
    public static var loggedInUserID: String?
}
