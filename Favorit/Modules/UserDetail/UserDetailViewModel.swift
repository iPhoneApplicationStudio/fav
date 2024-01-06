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
    var errorMessage: String? { get }
    
    func getUserDetail(hanlder: @escaping ((Result<User?, APIError>)?) -> Void)
    func followTheUser(hanlder: @escaping ((Result<Bool, APIError>)?) -> Void)
    func unFollowTheUser(hanlder: @escaping ((Result<Bool, APIError>)?) -> Void)
    
    func updateTheUser(tagLine: String?, hanlder: @escaping ((Result<Bool, APIError>)?) -> Void)
    func signout() -> Bool
}

class UserDetailViewModel: UserDetailViewProtocol {
    private var userID: String?
    private var _isEditEnable = false
    private var user: User?
    private var _errorMessage: String?
    
    private let userDetailService = UserDetailsService()
    private let userFollowService = UserFollowService()
    
    @Dependency var userSessionService: UserSessionService
    
    init?(userID: String?) {
        guard let userID else {
            return nil
        }
        
        self.userID = userID
        self._isEditEnable = isMyProfile
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
    
    var errorMessage: String? {
        _errorMessage
    }
    
    func getUserDetail(hanlder: @escaping ((Result<User?, APIError>)?) -> Void) {
        guard let userID else {
            hanlder(nil)
            return
        }
        
        self.userDetailService.getUserDetails(UserDetailRequest(userID: userID)) {[weak self] result in
            self?._errorMessage = nil
            switch result {
            case .success(let userDetail):
                guard let data = userDetail.data else {
                    self?._errorMessage = userDetail.message ?? Message.somethingWentWrong.value
                    hanlder(.success(nil))
                    return
                }
                
                self?.user = data
                hanlder(.success(data))
            case .failure(let failure):
                hanlder(.failure(failure))
            }
        }
    }
    
    func followTheUser(hanlder: @escaping ((Result<Bool, APIError>)?) -> Void) {
        guard let userID else {
            hanlder(nil)
            return
        }
        
        userFollowService.follow(userID: userID) {[weak self] result in
            self?._errorMessage = nil
            switch result {
            case .success(let response):
                if response.success == false {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                hanlder(.success(response.success))
            case.failure(let error):
                hanlder(.failure(error))
            }
        }
    }
    
    func unFollowTheUser(hanlder: @escaping ((Result<Bool, APIError>)?) -> Void) {
        guard let userID else {
            hanlder(nil)
            return
        }
        
        userFollowService.unFollow(userID: userID) {[weak self] result in
            self?._errorMessage = nil
            switch result {
            case .success(let response):
                if response.success == false {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                hanlder(.success(response.success))
            case.failure(let error):
                hanlder(.failure(error))
            }
        }
    }
    
    func updateTheUser(tagLine: String?,
                       hanlder: @escaping ((Result<Bool, APIError>)?) -> Void) {
        guard isMyProfile,
              let tagLine = tagLine,
              let userID else {
            hanlder(nil)
            return
        }
        
        let params = UserUpdateRequest.RequestParams(bio: tagLine)
        let request = UserUpdateRequest(queryParams: params,
                                        userID: userID)
        self.userDetailService.updateUserDetails(request) {[weak self] result in
            self?._errorMessage = nil
            switch result {
            case .success(let userDetail):
                guard let data = userDetail.data else {
                    self?._errorMessage = userDetail.message ?? Message.somethingWentWrong.value
                    hanlder(.success(false))
                    return
                }
                
                self?.user = data
                hanlder(.success(true))
            case .failure(let failure):
                hanlder(.failure(failure))
            }
        }
    }
    
    func signout() -> Bool {
        guard isMyProfile else {
            return false
        }
        
        UserDefaults.loggedInUserID = nil
        KeychainManager.remove(for: UserDefaults.accessTokenKey!)
        return true
    }
}
