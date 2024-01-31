//
//  VenueMapPinViews.swift
//  Favorit
//

import Foundation
import MapKit

class VenueMapPinViews: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let mapPinView = newValue as? VenueMapPin else { return }
            markerTintColor = mapPinView.markerTintColor
            if mapPinView.venueState == .favorit {
                clusteringIdentifier = "favoriteCluster"
            } else if mapPinView.venueState == .bookmark {
                clusteringIdentifier = "bookmarkCluster"
            }
        }
    }
}
