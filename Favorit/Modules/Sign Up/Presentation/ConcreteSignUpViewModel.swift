//
//  ConcreteSignUpViewModel.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

final class ConcreteSignUpViewModel: SignupViewModel {
    var signUpUserInput: SignUpUserInput = SignUpUserInput()
    var handleLoadingState: ((Bool) -> Void)?
    
    @Dependency var signupService: SignUpService
    
    func signUp(completion: @escaping (Result<SignUpResponse, SignupError>) -> Void) {
        let email = signUpUserInput.email
        guard let email, email.isValidMailID else {
            completion(.failure(.invalidEmail))
            return
        }
        
        let firstName = signUpUserInput.firstName
        guard let firstName, firstName.isNotEmpty else {
            completion(.failure(.invalidFirstName))
            return
        }
        
        let lastName = signUpUserInput.lastName
        guard let lastName, lastName.isNotEmpty else {
            completion(.failure(.invalidLastName))
            return
        }
        
        let password = signUpUserInput.password
        guard let password, password.isValidPassword else {
            completion(.failure(.invalidPassword))
            return
        }
        
        handleLoadingState?(true)
        let request = SignUpRequest(body: .init(email: email,
                                                name: "\(firstName) \(lastName)",
                                                password: password))
        signupService.signUp(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                completion(.failure(.signUpFailed))
            }
            self?.handleLoadingState?(false)
        }
    }
}
