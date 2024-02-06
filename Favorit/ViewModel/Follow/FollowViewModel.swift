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
    
    var query: String {
        switch self {
        case .follower:
            return "followers"
        case .following:
            return "followedBy"
        }
    }
}

protocol FollowProtocol: AnyObject {
    var title: String { get }
    var numberOfUsers: Int { get }
    var isMyProfile: Bool { get }
    
    var viewState: FollowViewState { get set }
    var didUpdateState: ((FollowViewState) -> Void)? { get set }
    var handleLoadingState: ((Bool) -> Void)? { get set }
    
    func userForIndex(_ index: Int) -> User?
    func loadUsers(shouldRefresh: Bool)
}

final class FollowViewModel: FollowProtocol {
    private var _viewState: FollowViewState = .loading
    private var users = [User]()
    private let networkService = FollowService()
    private let userID: String
    private let filterMode: FollowType

    var didUpdateState: ((FollowViewState) -> Void)?
    var handleLoadingState: ((Bool) -> Void)?
    
    @Dependency var userSessionService: UserSessionService
        
    init(userID: String,
         filterMode: FollowType) {
        self.userID = userID
        self.filterMode = filterMode
    }
    
    var isMyProfile: Bool {
        userSessionService.loggedInUserID == userID
    }
    
    var title: String {
        return filterMode == .following ? "Following" : "Follower"
    }
    
    var viewState: FollowViewState {
        get {
            return _viewState
        } set {
            _viewState = newValue
        }
    }

    var numberOfUsers: Int {
        return users.count
    }
    
    func userForIndex(_ index: Int) -> User? {
        guard index >= 0 || index < numberOfUsers else {
            return nil
        }
        
        return users[index]
    }
    
    func loadUsers(shouldRefresh: Bool = false) {
        if !shouldRefresh && self.users.count > 0 {
            self.didUpdateState?(.loaded)
            return
        }
        
        self.didUpdateState?(.loading)
        self.handleLoadingState?(true)
        filterMode == .following ? self.loadFollowingUsers() : self.loadFollowerUsers()
    }
    
    private func loadFollowingUsers() {
        let request = FollowRequest(userID: userID,
                                    type: filterMode.query)
        let handler: (Result<FollowingResponse, APIError>) -> Void = { [weak self] result in
            switch result {
            case .success(let response):
                self?.users.removeAll()
                guard let allUsersData = response.allUsersData else {
                    self?.didUpdateState?(.noUsers)
                    return
                }
                
                for data in allUsersData {
                    if let user = data.user {
                        self?.users.append(user)
                    }
                }
                
                self?.didUpdateState?(.loaded)
            case .failure(let error):
                self?.didUpdateState?(.error(.custom(error.localizedDescription)))
            }
            
            self?.handleLoadingState?(false)
        }
        
        networkService.allFollowingUsers(request: request, completion: handler)
    }
    
    private func loadFollowerUsers() {
        let request = FollowRequest(userID: userID,
                                    type: filterMode.query)
        let handler: (Result<FollowResponse, APIError>) -> Void = { [weak self] result in
            switch result {
            case .success(let response):
                self?.users.removeAll()
                guard let allUsersData = response.allUsersData else {
                    self?.didUpdateState?(.noUsers)
                    return
                }
                
                for data in allUsersData {
                    if let user = data.user {
                        self?.users.append(user)
                    }
                }
                
                self?.didUpdateState?(.loaded)
            case .failure(let error):
                self?.didUpdateState?(.error(.custom(error.localizedDescription)))
            }
            
            self?.handleLoadingState?(false)
        }
        
        networkService.allUsers(request: request, completion: handler)
    }
}
