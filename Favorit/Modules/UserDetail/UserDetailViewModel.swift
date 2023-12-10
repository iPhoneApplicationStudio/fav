//
//  UserDetailViewModel.swift
//  Favorit
//
//  Created by ONS on 07/12/23.
//

import Foundation

protocol UserDetailViewProtocol: AnyObject {
    var isEditMode: Bool { get }
    var isMyProfile: Bool { get }
    var isFollowedByMe: Bool { get }
    
    func getUserDetail(hanlder: @escaping ((Result<User, APIError>)?) -> Void)
    func followTheUser(hanlder: @escaping ((Result<UserFollowedResponse, APIError>)?) -> Void)
    func unFollowTheUser(hanlder: @escaping ((Result<Bool, APIError>)?) -> Void)
}

class UserDetailViewModel: UserDetailViewProtocol {
    private var userID: String?
    private var _isEditEnable = false
    private let userDetailService = UserDetailsService()
    private var user: User?
    private var followedResponse: UserFollowedResponse?
    
    @Dependency var userSessionService: UserSessionService
    @Dependency var userFollowService: UserFollowService
    
    init?(userID: String?,
          isEditMode: Bool) {
        guard let userID else {
            return nil
        }
        
        self.userID = userID
        self._isEditEnable = isEditMode
    }
    
    var isMyProfile: Bool {
        userSessionService.loggedInUserID == self.userID
    }
    
    var isEditMode: Bool {
        return _isEditEnable
    }
    
    var isFollowedByMe: Bool {
        return user?.followed ?? false
    }
    
    func getUserDetail(hanlder: @escaping ((Result<User, APIError>)?) -> Void) {
        guard let userID else {
            hanlder(nil)
            return
        }
        
        self.userDetailService.getUserDetails(UserDetailRequest(userID: userID)) {[weak self] result in
            switch result {
            case .success(let profileUser):
                self?.user = profileUser
                hanlder(.success(profileUser))
            case .failure(let failure):
                hanlder(.failure(failure))
            }
        }
    }
    
    func followTheUser(hanlder: @escaping ((Result<UserFollowedResponse, APIError>)?) -> Void) {
        guard let userID else {
            hanlder(nil)
            return
        }
        
        userFollowService.follow(userID: userID) {[weak self] result in
            switch result {
            case .success(let response):
                self?.followedResponse = response
                hanlder(.success(response))
            case.failure(let error):
                self?.followedResponse = nil
                hanlder(.failure(error))
            }
        }
    }
    
    func unFollowTheUser(hanlder: @escaping ((Result<Bool, APIError>)?) -> Void) {
        guard let userID, followedResponse != nil else {
            hanlder(nil)
            return
        }
        
        userFollowService.unFollow(userID: userID) {[weak self] result in
            self?.followedResponse = nil
            switch result {
            case .success:
                hanlder(.success(true))
            case.failure(let error):
                hanlder(.failure(error))
            }
        }
    }
}
