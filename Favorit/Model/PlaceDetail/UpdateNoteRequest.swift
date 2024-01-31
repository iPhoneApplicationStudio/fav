//
//  UpdateNoteRequest.swift
//  Favorit
//
//  Created by Abhinay Maurya on 23/01/24.
//

import Foundation
import Alamofire

struct UpdateNoteRequest: APIEndpoint {
    struct Body: Encodable {
        let note: String
    }
    
    let noteID: String
    let body: Body
    
    var urlString: String {
        baseURL + "/notes/\(noteID)"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        .put
    }
    
    var parameters: Encodable? {
        body
    }
}
