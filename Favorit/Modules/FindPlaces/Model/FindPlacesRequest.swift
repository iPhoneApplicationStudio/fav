//
//  FindPlacesRequest.swift
//  Favorit
//
//  Created by ONS on 08/12/23.
//

import Foundation
import Alamofire

struct FindPlacesRequest: APIEndpoint {
    struct RequestParams: Encodable {
        let query: String?
        let limit: Int
        let latLong: String
        let categories: String?
        let radius: Int
        let openNow: String?
        let sort: String?
        
        enum CodingKeys: String, CodingKey {
            case query, sort, categories, radius, limit
            case latLong = "ll"
            case openNow = "open_now"
        }
    }
    
    let queryParams: RequestParams
    
    var urlString: String {
        return baseURL + "/places"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        queryParams
    }
}
