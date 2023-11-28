//
//  KeychainManager.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation
import SwiftKeychainWrapper

final class KeychainManager {
    
    static func save(for key: String, value: String) {
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    static func retrieve(for key: String) -> String? {
        KeychainWrapper.standard.string(forKey: key)
    }
}
