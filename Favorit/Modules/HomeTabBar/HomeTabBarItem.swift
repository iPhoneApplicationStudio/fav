//
//  HomeTabBarItem.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

enum HomeTabBarItem: CaseIterable {
    case places
    case following
    case feed
    
    var icon: UIImage {
        switch self {
        case .places:
            return UIImage(resource: .bookmarkTab)
        case .following:
            return UIImage(resource: .followers)
        case .feed:
            return UIImage(resource: .feedIcon)
        }
    }
    
    var title: String {
        switch self {
        case .places:
            return "Places"
        case .following:
            return "Following"
        case .feed:
            return "Feed"
        
        }
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: title, 
                            image: icon,
                            selectedImage: icon.withTintColor(.primary))
    }
}
