//
//  UserFollowService.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation

final class UserFollowService {
    
    let networkService = NetworkService()
    
    func follow(userID: String, completion: @escaping (Result<UserFollowedResponse, APIError>) -> Void) {
        networkService.fetch(apiEndPoint: FollowersRequest(userID: userID), model: UserFollowedResponse.self, completion: completion)
    }
    
    func unFollow(userID: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        networkService.fetch(apiEndPoint: UnFollowUserRequest(userID: userID), model: Bool?.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
