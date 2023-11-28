//
//  FavoritConstant.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import UIKit

class FavoritConstant {
    private let isProdEnable = false
    private let prodUrl = ""
    private let devUrl = ""
    
    let downloadUrl = "https://apps.apple.com/us/app/favorit-foodie-restaurant-app/id1321962737"
    static let shared = FavoritConstant()
    private init() { }
    
    class var serverUrl: String {
        return FavoritConstant.shared.isProdEnable ? FavoritConstant.shared.prodUrl : FavoritConstant.shared.devUrl
    }
    
    class var headers: [String: String] {
        
        return [:]
    }
    
    
    struct Colors {
        static var primaryColor: UIColor? {
            return UIColor(named: "Primary")
        }
        
        static var accentColor: UIColor? {
            return UIColor(named: "Accent")
        }
        
        static let whiteGradientTop = UIColor.white.withAlphaComponent(0.0)
        static let whiteGradientBottom = UIColor.white
    }
}

enum StoryboardName: String {
    case main = "Main"
    case login = "Login"
    
    var value: String {
        return rawValue
    }
}

enum ViewControllerName: String {
    case login = "LoginVC"
    case tabbar = "TabBarVC"
    
    var value: String {
        return rawValue
    }
}

enum CellName: String {
    case inviteFriendsCell = "inviteFriendsCell"
    case followerCell = "followerCell"
    
    var value: String {
        return rawValue
    }
}


