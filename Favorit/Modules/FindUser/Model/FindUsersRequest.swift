//
//  AllUsersRequest.swift
//  Favorit
//
//  Created by ONS on 07/12/23.
//

import Foundation
import Alamofire

struct FindUsersRequest: APIEndpoint {
    struct RequestParams: Encodable {
        let search: String
        let page: Int
        let limit: Int
        let sortOrder: String
    }
    
    let queryParams: RequestParams
    
    var urlString: String {
        return baseURL + "/users"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        queryParams
    }
}
