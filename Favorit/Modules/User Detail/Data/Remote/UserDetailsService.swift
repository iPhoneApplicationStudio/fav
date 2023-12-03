//
//  UserDetailsService.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation

final class UserDetailsService {
    private let networkService = NetworkService()
    
    func getUserDetails(_ request: UserDetailRequest, completion: @escaping (Result<User, APIError>) -> Void) {
        networkService.fetch(apiEndPoint: request, model: User.self, completion: completion)
    }
}
