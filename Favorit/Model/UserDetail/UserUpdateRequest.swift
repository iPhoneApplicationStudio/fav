//
//  UserUpdateRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 23/12/23.
//

import Foundation
import Alamofire

struct UserUpdateRequest: APIEndpoint {
    struct RequestParams: Encodable {
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case bio
        }
    }
    
    let queryParams: RequestParams
    
    let userID: String
    
    var urlString: String {
        return baseURL + "/users/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .put
    }
    
    var parameters: Encodable? {
        return queryParams
    }
}
