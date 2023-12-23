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
}

class UserDetailViewModel: UserDetailViewProtocol {
    private var userID: String?
    private var _isEditEnable = false
    private let userDetailService = UserDetailsService()
    private var user: User?
    private var _errorMessage: String?
    
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
}
