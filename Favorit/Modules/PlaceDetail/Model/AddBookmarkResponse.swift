//
//  AddBookmarkResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

struct BookmarkResponse:  Codable {
    let success : Bool?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case success, message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
