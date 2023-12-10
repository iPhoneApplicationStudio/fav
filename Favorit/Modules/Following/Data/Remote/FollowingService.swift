//
//  FollowingService.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

protocol FollowingService {
    func allFollowers(request: FollowersRequest, completion: @escaping (Result<[FollowerUser], APIError>) -> Void)
}

extension NetworkService: FollowingService {
    func allFollowers(request: FollowersRequest, completion: @escaping (Result<[FollowerUser], APIError>) -> Void) {
        fetch(apiEndPoint: request, model: [FollowersResponse].self) { result in
            
            switch result {
            case .success(let response):
                let followers = UserFollowerMaper.map(from: response)
                completion(.success(followers))
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
}

private struct UserFollowerMaper {
    
    static func map(from followers: [FollowersResponse]) -> [FollowerUser] {
        followers.map { follower in
            let user = follower.user
            return FollowerUser(
                id: user?.id,
                name: user?.name,
                email: user?.email,
                followers: user?.followers?.integer ?? 0,
                following: user?.following?.integer ?? 0,
                avatar: nil)
        }
    }
}
