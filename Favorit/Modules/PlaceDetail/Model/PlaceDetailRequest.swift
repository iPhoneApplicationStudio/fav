//
//  PlaceDetailRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import Foundation
import Alamofire

struct PlaceDetailRequest: APIEndpoint {
    let placeID: String
    
    var urlString: String {
        baseURL + "/places/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
