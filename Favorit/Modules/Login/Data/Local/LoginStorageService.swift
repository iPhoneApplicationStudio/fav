//
//  LoginStorageService.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

protocol LoginStorageService {
    func store(token: String)
    func store(loggedIn userID: String)
}

final class ConcreteLoginStorageService: LoginStorageService {
    func store(token: String) {
        let key = UserDefaults.accessTokenKey ?? UUID().uuidString
        UserDefaults.accessTokenKey = key
        KeychainManager.save(for: key, value: token)
    }
    
    func store(loggedIn userID: String) {
        UserDefaults.loggedInUserID = userID
    }
}
