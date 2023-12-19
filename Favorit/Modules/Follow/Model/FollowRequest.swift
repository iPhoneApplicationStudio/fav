//
//  FollowersRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation
import Alamofire

struct FollowRequest: APIEndpoint {
    let userID: String
    let type: String
    
    var urlString: String {
        baseURL + "/followers/\(userID)?type=\(type)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
