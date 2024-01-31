//
//  NotificationHelper.swift
//  Favorit
//
//  Created by Abhinay Maurya on 25/01/24.
//

import Foundation

extension Notification.Name {
    static let refreshMyPlaces = Notification.Name("refreshMyPlaces")
}


struct NotificationHelper {    
    enum Post {
        case refreshMyPlaces
        
        func fire() {
            var notificationName: Notification.Name
            switch self {
            case .refreshMyPlaces:
                notificationName = Notification.Name.refreshMyPlaces
            }
            
            NotificationCenter.default.post(name: notificationName,
                                            object: nil)
        }
    }
}
