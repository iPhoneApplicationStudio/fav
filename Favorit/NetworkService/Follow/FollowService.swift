//
//  FollowingService.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

class FollowService {
    private let service = NetworkService()
    func allUsers(request: FollowRequest,
                  completion: @escaping (Result<FollowResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: FollowResponse.self,
                      isCustom: true,
                      completion: completion)
    }
    
    func allFollowingUsers(request: FollowRequest,
                           completion: @escaping (Result<FollowingResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: FollowingResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}
