//
//  SignUpService.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

protocol SignUpService {
    func signUp(request: SignUpRequest, completion: @escaping (Result<SignUpResponse, APIError>) -> Void)
}

extension NetworkService: SignUpService {
    func signUp(request: SignUpRequest, 
                completion: @escaping (Result<SignUpResponse, APIError>) -> Void) {
        fetch(apiEndPoint: request, 
              model: SignUpResponse.self,
              completion: completion)
    }
}
