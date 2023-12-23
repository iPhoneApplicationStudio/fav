//
//  BookmarkRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation
import Alamofire

struct AddBookmarkRequest: APIEndpoint {
    let placeID: String
    
    var urlString: String {
        baseURL + "/bookmarks/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .post
    }
    
    var parameters: Encodable? {
        nil
    }
}

struct RemoveBookmarkRequest: APIEndpoint {
    let placeID: String
    
    var urlString: String {
        baseURL + "/bookmarks/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .delete
    }
    
    var parameters: Encodable? {
        nil
    }
}

