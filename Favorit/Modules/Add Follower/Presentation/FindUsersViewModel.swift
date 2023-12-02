//
//  FindUsersViewModel.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

class FindUsersViewModel {
    
    private var users = [FollowerUser]()
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func userForIndex(_ index: Int) -> FollowerUser? {
        guard index >= 0 || index < numberOfUsers else {
            return nil
        }
        
        return users[index]
    }
    
    func getFollowers(handler: @escaping (Result<[FollowerUser], Error>) -> Void) {
        
    }
}
