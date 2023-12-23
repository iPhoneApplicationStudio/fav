//
//  UserDetailsService.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation

final class UserDetailsService {
    private let networkService = NetworkService()
    
    func getUserDetails(_ request: UserDetailRequest,
                        completion: @escaping (Result<UserDetail, APIError>) -> Void) {
        networkService.fetch(apiEndPoint: request,
                             model: UserDetail.self,
                             isCustom: true,
                             completion: completion)
    }
    
    func updateUserDetails(_ request: UserUpdateRequest,
                           completion: @escaping (Result<UserDetail, APIError>) -> Void) {
        networkService.fetch(apiEndPoint: request,
                             model: UserDetail.self,
                             isCustom: true,
                             completion: completion)
    }
}
