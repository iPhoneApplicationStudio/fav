//
//  FeedRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 02/02/24.
//

import Foundation
import Alamofire

struct FeedRequest: APIEndpoint {
    let userID: String
    
    var urlString: String {
        baseURL + "/activities/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
