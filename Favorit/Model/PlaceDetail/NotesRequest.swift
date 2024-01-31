//
//  NotesRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/01/24.
//

import Foundation
import Alamofire

struct NotesRequest: APIEndpoint {
    let placeID: String
    
    var urlString: String {
        baseURL + "/notes/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Encodable? {
        nil
    }
}
