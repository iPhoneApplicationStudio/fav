//
//  FavRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 11/01/24.
//

import Foundation
import Alamofire

struct AddFavouriteRequest: APIEndpoint {
    let placeID: String
    
    var urlString: String {
        baseURL + "/favourites/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .post
    }
    
    var parameters: Encodable? {
        nil
    }
}

struct RemoveFavouriteRequest: APIEndpoint {
    let placeID: String
    
    var urlString: String {
        baseURL + "/favourites/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .delete
    }
    
    var parameters: Encodable? {
        nil
    }
}

