//
//  LoginAPI.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation

protocol LoginService {
    func login(request: LoginRequest, 
               completion: @escaping (Result<LoginResponse, APIError>) -> Void)
}

extension NetworkService: LoginService {
    func login(request: LoginRequest, 
               completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        fetch(apiEndPoint: request, 
              model: LoginResponse.self, completion: completion)
    }
}
