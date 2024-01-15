//
//  SaveNoteRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 15/01/24.
//

import Foundation
import Alamofire

struct SaveNoteRequest: APIEndpoint {
    struct Body: Encodable {
        let note: String
    }
    
    let placeID: String
    let body: Body
    
    var urlString: String {
        baseURL + "/notes/\(placeID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .post
    }
    
    var parameters: Encodable? {
        body
    }
}
