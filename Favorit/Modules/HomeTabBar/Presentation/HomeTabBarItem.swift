//
//  HomeTabBarItem.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

enum HomeTabBarItem: CaseIterable {
    
    case places
    case follower
    
    var icon: UIImage {
        switch self {
        case .follower:
            return UIImage(resource: .followers)
        case .places:
            return UIImage(resource: .bookmarkTab)
        }
    }
    
    var title: String {
        switch self {
        case .follower:
            return "Follower"
        case .places:
            return "Places"
        }
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: title, image: icon, selectedImage: icon.withTintColor(.primary))
    }
}
