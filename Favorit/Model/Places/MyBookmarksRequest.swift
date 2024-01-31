//
//  MyBookmarksRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation
import Alamofire

struct MyBookmarksRequest: APIEndpoint {
    let userID: String
    
    var urlString: String {
        baseURL + "/bookmarks/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
