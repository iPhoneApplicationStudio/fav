//
//  DistanceHelper.swift
//  Favorit
//
//  Created by Chris Piazza on 12/2/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import Foundation
import CoreLocation

class DistanceHelper {
    
    static func venueDistanceFromUserLocation(lat: Double, lng: Double) -> Double {
        let venueLocation = CLLocation(latitude: lat, longitude: lng)
        let distance = LocationService.sharedInstance.currentLocation?.distance(from: venueLocation)
        
        return distance ?? 0.0
    }
    
    static func convertDistance(distance: Double) -> String {
        var convertedString = ""
        let locale = Locale.current //NSLocale.current
        let isMetric = locale.usesMetricSystem
        if isMetric {
            if distance < 1000 {
                convertedString = "\(Int(distance)) m"
            } else {
                let kilometers = distance / 1000
                convertedString = "\(kilometers.roundToDecimal(1)) km"
            }
        } else {
            let feetDistance = distance * 3.28
            if feetDistance < 1000 {
                convertedString = "\(Int(feetDistance)) ft"
            } else {
                let milesDistance = feetDistance / 5280
                convertedString = "\(milesDistance.roundToDecimal(1)) mi"
            }
        }
        return convertedString
    }
    
//    static func addDistanceFromUserAndSort(venueArray: [SavedVenue]) -> [SavedVenue] {
//        var sortedVenueArray = [SavedVenue]()
//        for venue in venueArray {
//            let distance = getDistance(favoritVenue: venue.favoritVenue)
//            venue.favoritVenue?.distance = distance as NSNumber
//            venue.favoritVenue?.distanceStr = convertDistance(distance: distance)
//            sortedVenueArray.append(venue)
//        }
//        
//        sortedVenueArray.sort(by: { ($0.favoritVenue?.distance?.doubleValue ?? 0) < ($1.favoritVenue?.distance?.doubleValue ?? 0 )})
//        
//        return sortedVenueArray
//    }
//    
//    private static func getDistance(favoritVenue: FavoritVenue?) -> Double {
//        guard let lat = favoritVenue?.lat?.doubleValue,
//            let lng = favoritVenue?.lng?.doubleValue
//            else {return 0}
//        let distance = DistanceHelper.venueDistanceFromUserLocation(lat: lat, lng: lng)
//        return distance
//    }
}
