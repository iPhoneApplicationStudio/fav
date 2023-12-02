//
//  AllUsersService.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation
import Alamofire

struct AllUsersRequest: APIEndpoint {
    
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

class AllUsersService {
    private let service = NetworkService()
    func getAllUsers(request: AllUsersRequest, completion: @escaping (Result<UserPage, APIError>) -> Void) {
        service.fetch(apiEndPoint: request, model: UserPage.self, isCustom: true, completion: completion)
    }
}
