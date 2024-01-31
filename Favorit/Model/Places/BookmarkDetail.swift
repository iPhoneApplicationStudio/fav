//
//  BookmarkResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

struct PlaceDetail: Codable {
    let id : String
    let user: PlaceUser?
    let place: Place?
    let active: Bool?

    enum CodingKeys: String, CodingKey {
        case user, place, active
        case id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        user = try values.decodeIfPresent(PlaceUser.self, forKey: .user)
        place = try values.decodeIfPresent(Place.self, forKey: .place)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
    }
}
