//
//  SignupViewModel.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

enum SignupError: Error {
    case invalidEmail
    case invalidFirstName
    case invalidLastName
    case invalidPassword
    case signUpFailed
    
    var message: String {
        switch self {
        case .invalidEmail:
            "Please enter a valid email."
        case .invalidFirstName:
            "Please enter first name."
        case .invalidLastName:
            "Please enter last name."
        case .invalidPassword:
            "Please enter valid password (minimum 8 characters)"
        case .signUpFailed:
            "Something went wrong. Please try again later."
        }
    }
}

protocol SignupViewModel {
    
    var signUpUserInput: SignUpUserInput { get set }
    
    var handleLoadingState: ((Bool) -> Void)? { get set }
    
    func signUp(completion: @escaping (Result<SignUpResponse, SignupError>) -> Void)
}
