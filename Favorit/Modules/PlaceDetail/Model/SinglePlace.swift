//
//  SinglePlace.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import Foundation

struct SinglePlace:  Codable {
    let success : Bool?
    let message : String?
    let place : Place?

    enum CodingKeys: String, CodingKey {
        case success, message
        case place = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        place = try values.decodeIfPresent(Place.self, forKey: .place)
    }
}
