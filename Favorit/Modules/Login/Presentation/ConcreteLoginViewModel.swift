//
//  ConcreteLoginViewModel.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation

final class ConcreteLoginViewModel: LoginViewModel {
    
    @Dependency var loginService: LoginService
    @Dependency var loginStorageService: LoginStorageService
    
    var handleLoadingState: ((Bool) -> Void)?
    
    func isValidEmail(_ mail: String) -> Bool {
        return mail.isValidMailID
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.isValidPassword
    }
    
    func loginRequest(
        email: String?,
        password: String?,
        completion: @escaping LoginHandler) {
            
            guard let email, isValidEmail(email) else {
                completion(.failure(.invalidEmail))
                return
            }
        
            guard let password, isValidPassword(password) else {
                completion(.failure(.invalidPassword))
                return
            }
        
            handleLoadingState?(true)
            let request = LoginRequest(params: .init(email: email, password: password))
            loginService.login(request: request) { [weak self] result in
                switch result {
                case .success(let response):
                    if let token = response.token {
                        self?.loginStorageService.store(token: token)
                    }
                    if let userID = response.id {
                        self?.loginStorageService.store(loggedIn: userID)
                    }
                    completion(.success(response))
                case .failure:
                    completion(.failure(.loginFailed))
                }
                self?.handleLoadingState?(false)
            }
    }
}
