//
//  AllPlacesData.swift
//  Favorit
//
//  Created by ONS on 06/12/23.
//

import Foundation

struct Place : Codable {
    var isBookmarked: Bool
    var isFavourite: Bool
    let placeId: String
    let categories: [PlaceCategory]?
    let location : PlaceLocation?
    let name : String?
    var distance: Double?
    let photos: [String]?
    let geocodes: Geocodes?
    let bookmarkCount: Int?
    let favouriteCount: Int?
    
    var distanceString: String? {
        guard let distance else {
            return nil
        }
        
        return DistanceHelper.convertDistance(distance: distance)
    }
    
    var featurePhotoURL: String? {
        return photos?.first
    }
    
    var featureCategory: String? {
        return categories?.first?.name
    }
    
    var categoryIconURL: String? {
        let icon = categories?.first?.icon
        guard let iconPrefix = icon?.prefix,
              let iconSuffix = icon?.suffix else {
            return nil
        }
        
        return "\(iconPrefix)\(iconSuffix)"
    }

    enum CodingKeys: String, CodingKey {
        case isBookmarked = "isBookmarked"
        case isFavourite = "isFavourite"
        case placeId = "fsq_id"
        case categories = "categories"
        case location = "location"
        case name = "name"
        case distance = "distance"
        case photos = "photos"
        case geocodes = "geocodes"
        case bookmarkCount = "bookmarkCount"
        case favouriteCount = "favouriteCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isBookmarked = try values.decode(Bool.self, forKey: .isBookmarked)
        isFavourite = try values.decode(Bool.self, forKey: .isFavourite)
        placeId = try values.decode(String.self, forKey: .placeId)
        categories = try values.decodeIfPresent([PlaceCategory].self, forKey: .categories)
        location = try values.decodeIfPresent(PlaceLocation.self, forKey: .location)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        photos = try values.decodeIfPresent([String].self, forKey: .photos)
        geocodes = try values.decodeIfPresent(Geocodes.self, forKey: .geocodes)
        bookmarkCount = try values.decodeIfPresent(Int.self, forKey: .bookmarkCount)
        favouriteCount = try values.decodeIfPresent(Int.self, forKey: .favouriteCount)
    }
}
