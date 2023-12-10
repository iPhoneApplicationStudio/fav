//
//  FavoritConstant.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import UIKit

class FavoritConstant {
    private let isProdEnable = false
    private let prodUrl = "http://54.160.165.153:5001/api/v1"
    private let devUrl = "http://52.201.240.52:5001/api/v1"
    
    let downloadUrl = "https://apps.apple.com/us/app/favorit-foodie-restaurant-app/id1321962737"
    static let shared = FavoritConstant()
    private init() { }
    
    class var serverUrl: String {
        return FavoritConstant.shared.isProdEnable ? FavoritConstant.shared.prodUrl : FavoritConstant.shared.devUrl
    }
    
    class var headers: [String: String] {
        
        return [:]
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
    case userDetail = "UserDetailsViewController"
    
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


