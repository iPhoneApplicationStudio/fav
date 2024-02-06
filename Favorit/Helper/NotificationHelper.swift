//
//  NotificationHelper.swift
//  Favorit
//
//  Created by Abhinay Maurya on 25/01/24.
//

import Foundation

extension Notification.Name {
    static let refreshMyPlaces = Notification.Name("refreshMyPlaces")
    static let refreshUserRecommendedPlaces = Notification.Name("refreshUserRecommendedPlaces")
    static let refreshPlacesOnMap = Notification.Name("refreshPlacesOnMap")
}


struct NotificationHelper {    
    enum Post {
        case refreshMyPlaces
        case refreshPlacesOnMap
        case refreshUserRecommendedPlaces([PlaceDetail])
        
        func fire() {
            var notificationName: Notification.Name
            switch self {
            case .refreshMyPlaces:
                notificationName = Notification.Name.refreshMyPlaces
            case .refreshPlacesOnMap:
                notificationName = Notification.Name.refreshPlacesOnMap
            case .refreshUserRecommendedPlaces(let places):
                notificationName = Notification.Name.refreshUserRecommendedPlaces
                NotificationCenter.default.post(name: notificationName,
                                                object: places)
                return
            }
            
            NotificationCenter.default.post(name: notificationName,
                                            object: nil)
        }
    }
}
