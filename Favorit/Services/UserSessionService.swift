//
//  UserSessionService.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

protocol UserSessionService {
    var isLoggedIn: Bool { get }
    var loggedInUserID: String? { get }
}

final class ConcreteUserSessionService: UserSessionService {
    var isLoggedIn: Bool {
        guard let key = UserDefaults.accessTokenKey else {
            return false
        }
        
        return KeychainManager.retrieve(for: key) != nil
    }
    
    var loggedInUserID: String? {
        UserDefaults.loggedInUserID
    }
}

extension ServiceLocator {
    static func registerUserSession() {
        register { ConcreteUserSessionService() }.conforms(UserSessionService.self)
    }
}
