//
//  Geocodes.swift
//  Favorit
//
//  Created by Abhinay Maurya on 13/12/23.
//

import Foundation

struct Geocodes : Codable {
    let main : LatLong?
    let roof : LatLong?

    enum CodingKeys: String, CodingKey {
        case main = "main"
        case roof = "roof"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        main = try values.decodeIfPresent(LatLong.self, forKey: .main)
        roof = try values.decodeIfPresent(LatLong.self, forKey: .roof)
    }
}

struct LatLong : Codable {
    let latitude : Double?
    let longitude : Double?

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }

}
