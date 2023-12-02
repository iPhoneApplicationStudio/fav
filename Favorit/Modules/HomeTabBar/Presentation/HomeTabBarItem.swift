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
    
    var icon: UIImage {
        switch self {
        case .following:
            return UIImage(resource: .followers)
        case .places:
            return UIImage(resource: .bookmarkTab)
        }
    }
    
    var title: String {
        switch self {
        case .following:
            return "Following"
        case .places:
            return "Places"
        }
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: title, image: icon, selectedImage: icon.withTintColor(.primary))
    }
}
