//
//  Login+Dependencies.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation

extension ServiceLocator {
    
    public static func registerLoginDependencies() {
        register { ConcreteLoginViewModel() }.conforms(LoginViewModel.self)
        register { NetworkService() }.conforms(LoginService.self)
        register { ConcreteLoginStorageService() }.conforms(LoginStorageService.self)
    }
}
