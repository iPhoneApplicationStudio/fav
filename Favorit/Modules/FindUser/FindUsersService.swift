//
//  AllUsersService.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

class FindUsersService {
    private let service = NetworkService()
    func getAllUsers(request: FindUsersRequest,
                     completion: @escaping (Result<UserPage, APIError>) -> Void) {
        service.fetch(apiEndPoint: request, 
                      model: UserPage.self,
                      isCustom: true,
                      completion: completion)
    }
}
