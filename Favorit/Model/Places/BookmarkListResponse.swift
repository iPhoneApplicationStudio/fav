//
//  PlaceListResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

struct PlaceListResponse: Codable {
    let success : Bool?
    let message : String?
    let allPlaces : [PlaceDetail]?

    enum CodingKeys: String, CodingKey {
        case success, message
        case allPlaces = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        allPlaces = try values.decodeIfPresent([PlaceDetail].self, forKey: .allPlaces)
    }
}
