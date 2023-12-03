//
//  UnFollowUserRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation
import Alamofire

struct UnFollowUserRequest: APIEndpoint {
    
    let userID: String
    
    var urlString: String {
        baseURL + "/followers/unfollow/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .delete
    }
    
    var parameters: Encodable? {
        return nil
    }
    
    
}
