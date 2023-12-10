//
//  FollowersRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation
import Alamofire

struct FollowersRequest: APIEndpoint {
    
    let userID: String
    
    var urlString: String {
        baseURL + "/followers/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
