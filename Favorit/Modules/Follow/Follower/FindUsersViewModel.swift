//
//  FindUsersViewModel.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

class FindUsersViewModel: FollowingUserProtocol {
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
