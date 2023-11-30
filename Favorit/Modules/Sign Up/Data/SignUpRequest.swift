//
//  SignUpRequest.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation
import Alamofire

struct SignUpRequest: APIEndpoint {
    
    struct Body: Encodable {
        let email: String
        let name: String
        let password: String
    }
    
    let body: Body
    
    var urlString: String {
        baseURL + "/auth/register"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .post
    }
    
    var parameters: Encodable {
        body
    }
}
