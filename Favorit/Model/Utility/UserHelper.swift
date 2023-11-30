//
//  UserHelper.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

class UserHelper {
    static let shared = UserHelper()
    private let prefs = UserDefaults.standard
    private init() { }
    
    enum Keys: String {
        case login
    }
    
    var isLogin: Bool {
        return !prefs.bool(forKey: Keys.login.rawValue)
    }
    
    func setUserLogin(flag: Bool) {
        prefs.setValue(flag, forKey: Keys.login.rawValue)
    }
}

