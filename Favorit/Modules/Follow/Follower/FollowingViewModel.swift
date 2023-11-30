//
//  FollowingViewModel.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

protocol FollowingUserProtocol: AnyObject {
    var numberOfUsers: Int { get }
    
    func userForIndex(_ index: Int) -> UserProtocol?
    func getAllUsers(handler: @escaping LoginHandler)
}

class FollowingViewModel: FollowingUserProtocol {
    private var users = __followings //[Following]()
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func userForIndex(_ index: Int) -> UserProtocol? {
        guard index >= 0 || index < numberOfUsers else {
            return nil
        }
        
        return users[index]
    }
    
    func getAllUsers(handler: @escaping LoginHandler) {
        handler(nil)
    }
}
