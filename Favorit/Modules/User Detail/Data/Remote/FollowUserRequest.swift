//
//  FollowUserRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation
import Alamofire

struct FollowUserRequest: APIEndpoint {
    
    let userID: String
    
    var urlString: String {
        baseURL + "followers/follow/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: Encodable? {
        return nil
    }
    
}
