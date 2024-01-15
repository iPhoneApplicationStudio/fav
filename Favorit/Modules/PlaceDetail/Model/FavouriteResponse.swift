//
//  FavoriteResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 11/01/24.
//

import Foundation

struct FavouriteResponse:  Codable {
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
