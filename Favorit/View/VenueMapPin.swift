//
//  VenueMapPin.swift
//  Popn
//
//  Created by Chris Piazza on 3/8/17.
//  Copyright © 2017 Chris Piazza. All rights reserved.
//

import Foundation
import MapKit

class VenueMapPin: NSObject, MKAnnotation {
    var title: String?
    var address: String?
    var venueCategory: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var venueState: PlaceState = .favorit
    
    var place: Place?
    
    init(place: Place?) {
        self.place = place
        if place?.isBookmarked ?? false {
            venueState = .bookmark
        }
        
        guard let place else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0, 
                                                     longitude: 0)
            return
        }
        
        self.title = place.name
        self.address = place.location?.formattedAddress ?? ""
        self.venueCategory = place.featureCategory
        self.subtitle = self.address
        
        guard let lat = place.geocodes?.main?.latitude,
              let lng = place.geocodes?.main?.longitude else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0,
                                                     longitude: 0)
            return
        }
        
        self.coordinate = CLLocationCoordinate2D(latitude: lat,
                                                 longitude: lng)
    }

    var markerTintColor: UIColor  {
        switch venueState {
        case .favorit:
            return .accentColor ?? .gray
        case .bookmark:
            return .primaryColor ?? .gray
        default:
            return .green
        }
    }
}
