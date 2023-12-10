//
//  FollowingViewModel.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

enum FollowingState {
    case loading
    case noFollowingUsers
    case loaded
    case error(FollowingError)
}

enum FollowingError: Error {
    case failed
    case notLoggedIn
    
    var message: String {
        switch self {
        case .notLoggedIn:
            return "Session expired."
        case .failed:
            return "Error."
        }
    }
}

protocol FollowingViewModel {
    
    var state: FollowingState { get set }
    var didUpdateState: ((FollowingState) -> Void)? { get set }
    var handleLoadingState: ((Bool) -> Void)? { get set }
    var numberOfUsers: Int { get }
    
    func userForIndex(_ index: Int) -> FollowerUser?
    func getFollowers()
}

final class ConcreteFollowingViewModel: FollowingViewModel {
    
    @Dependency private(set) var userSessionService: UserSessionService
    @Dependency private(set) var followingService: FollowingService
    
    var state: FollowingState = .loading
    private var users = [FollowerUser]()
    
    var didUpdateState: ((FollowingState) -> Void)?
    var handleLoadingState: ((Bool) -> Void)?
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func userForIndex(_ index: Int) -> FollowerUser? {
        guard index >= 0 || index < numberOfUsers else {
            return nil
        }
        
        return users[index]
    }
    
    func getFollowers() {
        
        guard 
            userSessionService.isLoggedIn,
            let userID = userSessionService.loggedInUserID 
        else {
            didUpdateState?(.error(.notLoggedIn))
            return
        }
        didUpdateState?(.loading)
        handleLoadingState?(true)
        let request = FollowersRequest(userID: userID)
        followingService.allFollowers(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                self?.users = data
                if data.isEmpty {
                    self?.didUpdateState?(.noFollowingUsers)
                } else {
                    self?.didUpdateState?(.loaded)
                }
            case .failure:
                self?.didUpdateState?(.error(.failed))
            }
            self?.handleLoadingState?(false)
        }
    }
}
