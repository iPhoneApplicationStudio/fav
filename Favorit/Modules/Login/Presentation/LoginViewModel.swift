//
//  LoginViewModel.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation
import Alamofire

typealias LoginHandler = (((Result<LoginResponse, LoginError>)) -> Void)

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
    case loginFailed
    
    var message: String {
        switch self {
        case .invalidEmail:
            return "Please enter valid Email"
        case .invalidPassword:
            return "Please enter your password (min 8 chars)"
        case .loginFailed:
            return "Login failed due to some reason. Please try again later."
        }
    }
}

protocol LoginViewModel: AnyObject {
    
    var handleLoadingState: ((Bool) -> Void)? { get set }
    
    func isValidEmail(_ mail: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    
    func loginRequest(email: String?,
                      password: String?,
                      completion: @escaping LoginHandler)
}
