//
//  FavoritConstant.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import UIKit

class FavoritConstant {
    private let isProdEnable = false
    private let prodUrl = "http://3.19.47.15:5000/api/v1"
    private let devUrl = "http://3.19.47.15:5000/api/v1"
    
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
    case favoritNavVC = "FavoritNavigationViewController"
    case mapVC = "MapViewController"
    case followVC = "FollowViewController"
    case placeDetailVC = "PlaceDetailViewController"
    
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

enum Message: String {
    case somethingWentWrong
    
    var value: String {
        switch self{
        case .somethingWentWrong:
            return "Something went wrong!!"
        }
    }
}

struct PlacesEmptyResultsStrings {
    static let myPlacesEmpty = "You don't have any places saved. 'Favorit' places to add to your top 10 list, 'Bookmark' places you are interested in."
    static let followersEmpty = "The people you are following have not saved any venues. Follow more friends and see their Bookmarked venues here."
    static let worldEmpty = "No one has saved any venues. Be the first and you'll be our favorite user ever"
    static let profileEmpty = "has not saved any venues yet."
}

struct FeedEmptyResultsStrings {
    static let noFeedResults = "When you follow friends, you will see their activity here."
    static let filterEmpty = "No one you follow has performed this action."
    static let notLoggedInFilter = "You need to be logged in to see your friend's activity"
}

struct TipsEmptyResultsStrings {
    static let notLoggedIn = "Please login or register to see the notes for this venue."
    static let loggedIn = "Be the first to leave a note for this venue!"
}

struct FollowersEmptyResultsStrings {
    static let emptyResultsFollowing = "is not following anyone."
    static let emptyResultsFollowers = "is not being followed."
    static let myEmptyResultsFollowing = "You are not following anyone."
    static let myEmptyResultsFollowers = "You are not being followed."
    static let emptyVenueResultsString = "Be the first to add this venue to your list!"

    
}
