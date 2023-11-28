//
//  SignUp+Dependencies.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

extension ServiceLocator {
    
    static func registerSignUpDependencies() {
        register { ConcreteSignUpViewModel() }.conforms(SignupViewModel.self)
        register { NetworkService() }.conforms(SignUpService.self)
    }
}
