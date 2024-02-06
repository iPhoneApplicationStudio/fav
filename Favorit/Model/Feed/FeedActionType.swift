//
//  FeedActionType.swift
//  Favorit
//
//  Created by Abhinay Maurya on 02/02/24.
//

import Foundation

enum FeedActionType: String, CaseIterable {
    //    case tip = "Tip"
    case follow = "Follow"
    case favorit = "Favorit"
    case bookmark = "Bookmark"
    case share = "Share"
    case news = "News"
    
    static let allValuesFilterStrings = ["\(follow.rawValue)s", 
                                         "\(favorit.rawValue)s",
                                         "\(bookmark.rawValue)s",
                                         "\(share.rawValue)s"]
    
    var actionMessage: String {
        switch self {
        //        case .tip: return " left a tip for "
        case .follow: return " followed "
        case .favorit: return " Favorit'd "
        case .bookmark: return  " bookmarked "
        case .share: return  " shared "
        case .news: return  ""
        }
    }
    
    var displayValue: String {
        return "\(self.rawValue)s"
    }
    
//    func getActionTargetString(action: TimelineAction) -> String? {
//        switch self {
//        //            case .tip: return action.venueName
//        case .follow: return action.followedUserFullName
//        case .favorit: return action.venueName
//        case .bookmark: return  action.venueName
//        case .share: return  action.venueName
//        case .news: return action.venueName
//        }
//    }
    
//    func getActionTargetObjectId(action: TimelineAction) -> (String?, String?) {
//        switch self {
//        //        case .tip: return (action.userId, action.venueId)
//        case .follow: return (action.userId, action.followedUserId)
//        case .favorit: return (action.userId, action.venueId)
//        case .bookmark: return  (action.userId, action.venueId)
//        case .share: return  (action.userId, action.venueId)
//        case .news: return (action.venueId, "")
//        }
//    }
}
