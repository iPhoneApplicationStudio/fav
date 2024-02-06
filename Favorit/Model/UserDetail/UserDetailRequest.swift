//
//  UserDetailRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation
import Alamofire

struct UserDetailRequest: APIEndpoint {
    let userID: String
    
    var urlString: String {
        return baseURL + "/users/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        return nil
    }
}
