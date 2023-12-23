//
//  HomeTabBarItem.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

enum HomeTabBarItem: CaseIterable {
    
    case places
    case tracking
    
    var icon: UIImage {
        switch self {
        case .tracking:
            return UIImage(resource: .followers)
        case .places:
            return UIImage(resource: .bookmarkTab)
        }
    }
    
    var title: String {
        switch self {
        case .tracking:
            return "Tracking"
        case .places:
            return "Places"
        }
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: title, image: icon, selectedImage: icon.withTintColor(.primary))
    }
}
