//
//  AllPlacesData.swift
//  Favorit
//
//  Created by ONS on 06/12/23.
//

import Foundation

struct SearchedPlace : Codable {
//    let fsq_id : String?
//    let categories : [Categories]?
//    let chains : [String]?
//    let closed_bucket : String?
//    let distance : Int?
//    let geocodes : Geocodes?
//    let link : String?
//    let location : Location?
    let name : String?
//    let related_places : Related_places?
//    let timezone : String?

    enum CodingKeys: String, CodingKey {

//        case fsq_id = "fsq_id"
//        case categories = "categories"
//        case chains = "chains"
//        case closed_bucket = "closed_bucket"
//        case distance = "distance"
//        case geocodes = "geocodes"
//        case link = "link"
//        case location = "location"
        case name = "name"
//        case related_places = "related_places"
//        case timezone = "timezone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        fsq_id = try values.decodeIfPresent(String.self, forKey: .fsq_id)
//        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
//        chains = try values.decodeIfPresent([String].self, forKey: .chains)
//        closed_bucket = try values.decodeIfPresent(String.self, forKey: .closed_bucket)
//        distance = try values.decodeIfPresent(Int.self, forKey: .distance)
//        geocodes = try values.decodeIfPresent(Geocodes.self, forKey: .geocodes)
//        link = try values.decodeIfPresent(String.self, forKey: .link)
//        location = try values.decodeIfPresent(Location.self, forKey: .location)
        name = try values.decodeIfPresent(String.self, forKey: .name)
//        related_places = try values.decodeIfPresent(Related_places.self, forKey: .related_places)
//        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
    }

}
