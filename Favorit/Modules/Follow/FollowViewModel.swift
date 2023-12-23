//
//  FollowingViewModel.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

enum FollowViewState {
    case loading
    case noUsers
    case loaded
    case error(FollowError)
}

enum FollowError: Error {
    case failed
    case notLoggedIn
    case custom(String)
    
    var message: String {
        switch self {
        case .notLoggedIn:
            return "Session expired."
        case .failed:
            return "Error."
        case .custom(let message):
            return message
        }
    }
}

enum FollowType: Int {
    case following, follower
}

protocol FollowProtocol: AnyObject {
    var title: String { get }
    var numberOfFollowingUsers: Int { get }
    var numberOfFollowerUsers: Int { get }
    
    var viewState: FollowViewState { get set }
    var didUpdateState: ((FollowViewState) -> Void)? { get set }
    var handleLoadingState: ((Bool) -> Void)? { get set }
    
    func followingUserForIndex(_ index: Int) -> User?
    func followerUserForIndex(_ index: Int) -> User?
    func getFollowingUsers(shouldRefresh: Bool)
    func getFollowerUsers(shouldRefresh: Bool)
}

final class FollowViewModel: FollowProtocol {
    private var _viewState: FollowViewState = .loading
    private var followingUsers = [User]()
    private var followerUsers = [User]()
    private let networkService = FollowService()

    var didUpdateState: ((FollowViewState) -> Void)?
    var handleLoadingState: ((Bool) -> Void)?
    
    @Dependency private(set) var userSessionService: UserSessionService
    
    var title: String {
        return "Tracking"
    }
    
    var viewState: FollowViewState {
        get {
            return _viewState
        } set {
            _viewState = newValue
        }
    }

    var numberOfFollowingUsers: Int {
        return followingUsers.count
    }
    
    var numberOfFollowerUsers: Int {
        return followerUsers.count
    }
    
    func followingUserForIndex(_ index: Int) -> User? {
        guard index >= 0 || index < numberOfFollowingUsers else {
            return nil
        }
        
        return followingUsers[index]
    }
    
    func followerUserForIndex(_ index: Int) -> User? {
        guard index >= 0 || index < numberOfFollowerUsers else {
            return nil
        }
        
        return followerUsers[index]
    }
    
    func getFollowingUsers(shouldRefresh: Bool = false) {
        self.getAllFollowing(shouldRefresh: shouldRefresh)
    }
    
    func getFollowerUsers(shouldRefresh: Bool = false) {
        self.getAllFollowers(shouldRefresh: shouldRefresh)
    }
    
    private func getAllFollowers(shouldRefresh: Bool = false) {
        guard
            userSessionService.isLoggedIn,
            let userID = userSessionService.loggedInUserID
        else {
            self.didUpdateState?(.error(.notLoggedIn))
            return
        }
        
        if !shouldRefresh && self.followerUsers.count > 0 {
            self.didUpdateState?(.loaded)
            return
        }
        
        self.didUpdateState?(.loading)
        self.handleLoadingState?(true)
        let request = FollowRequest(userID: userID,
                                    type: "followers")
        
        networkService.allUsers(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.followerUsers.removeAll()
                guard let allUsersData = response.allUsersData else {
                    self?.didUpdateState?(.noUsers)
                    return
                }
                
                for data in allUsersData {
                    if let user = data.user {
                        self?.followerUsers.append(user)
                    }
                }
                
                self?.didUpdateState?(.loaded)
            case .failure(let error):
                self?.didUpdateState?(.error(.custom(error.localizedDescription)))
            }
            
            self?.handleLoadingState?(false)
        }
    }
    
    private func getAllFollowing(shouldRefresh: Bool = false) {
        guard
            userSessionService.isLoggedIn,
            let userID = userSessionService.loggedInUserID
        else {
            self.didUpdateState?(.error(.notLoggedIn))
            return
        }
        
        if !shouldRefresh &&  self.followingUsers.count > 0 {
            self.didUpdateState?(.loaded)
            return
        }
        
        self.didUpdateState?(.loading)
        self.handleLoadingState?(true)
        let request = FollowRequest(userID: userID,
                                    type: "followedBy")
        
        networkService.allFollowingUsers(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.followingUsers.removeAll()
                guard let allUsersData = response.allUsersData else {
                    self?.didUpdateState?(.noUsers)
                    return
                }
                
                for data in allUsersData {
                    if let user = data.user {
                        self?.followingUsers.append(user)
                    }
                }
                
                self?.didUpdateState?(.loaded)
            case .failure(let error):
                self?.didUpdateState?(.error(.custom(error.localizedDescription)))
            }
            
            self?.handleLoadingState?(false)
        }
    }
}
