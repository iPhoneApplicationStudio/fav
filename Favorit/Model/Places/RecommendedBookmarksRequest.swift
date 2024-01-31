//
//  RecommendedPlacesRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation
import Alamofire

struct RecommendedBookmarksRequest: APIEndpoint {
    let userID: String
    
    var urlString: String {
        baseURL + "/bookmarks/recommanded/\(userID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
