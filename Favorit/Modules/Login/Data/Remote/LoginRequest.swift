//
//  LoginRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Alamofire

struct LoginRequest: APIEndpoint {    
    
    struct Parameters: Encodable {
        let email: String
        let password: String
    }
    
    let params: Parameters
    
    init(params: Parameters) {
        self.params = params
    }
    
    var urlString: String {
        baseURL + "/auth/login"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: Encodable? {
        params
    }
}
