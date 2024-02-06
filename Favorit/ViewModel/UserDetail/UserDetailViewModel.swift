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
    var errorMessage: String { get }
    var allBookmarkedPlaces: [PlaceDetail]? { get }
    
    func getBookmarkPlaceFor(index: Int) -> PlaceDetail?
    func getUserDetail(hanlder: @escaping (Result<User?, APIError>) -> Void)
    func followTheUser(hanlder: @escaping (Result<Bool, APIError>) -> Void)
    func unFollowTheUser(hanlder: @escaping (Result<Bool, APIError>) -> Void)
    
    func updateTheUser(tagLine: String?, hanlder: @escaping ((Result<Bool, APIError>)?) -> Void)
    func getBookmarks(handler: @escaping (Result<Bool, Error>) -> Void)
    func signout() -> Bool
}

class UserDetailViewModel: UserDetailViewProtocol {
    //MARK: Private Properties
    private var bookmarkedPlaces = [PlaceDetail]()
    private let userID: String
    private var _isEditEnable = false
    private var user: User?
    private var _errorMessage: String?
    
    private let userDetailService = UserDetailsService()
    private let userFollowService = UserFollowService()
    private let listService = PlaceListService()
    
    @Dependency var userSessionService: UserSessionService
    
    //MARK: Init
    init(userID: String) {
        self.userID = userID
        self._isEditEnable = isMyProfile
    }
    
    //MARK: Properties
    var isMyProfile: Bool {
        userSessionService.loggedInUserID == self.userID
    }
    
    var isEditMode: Bool {
        return _isEditEnable
    }
    
    var isFollowedByMe: Bool {
        return user?.followed ?? false
    }
    
    var allBookmarkedPlaces: [PlaceDetail]? {
        bookmarkedPlaces
    }
    
    var errorMessage: String {
        _errorMessage ?? Message.somethingWentWrong.value
    }
    
    //MARK: Methods
    func getBookmarkPlaceFor(index: Int) -> PlaceDetail? {
        guard index >= 0, index < bookmarkedPlaces.count else {
            return nil
        }
        
        return bookmarkedPlaces[index]
    }
    
    func getUserDetail(hanlder: @escaping (Result<User?, APIError>) -> Void) {
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
    
    func followTheUser(hanlder: @escaping (Result<Bool, APIError>) -> Void) {
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
    
    func unFollowTheUser(hanlder: @escaping (Result<Bool, APIError>) -> Void) {
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
              let tagLine = tagLine else {
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
    
    func getBookmarks(handler: @escaping (Result<Bool, Error>) -> Void) {
        let request = MyBookmarksRequest(userID: userID)
        listService.getAllMyBookmarks(request: request) {[weak self] result in
            self?.bookmarkedPlaces.removeAll()
            switch result {
            case .success(let myPlaces):
                if myPlaces.success ?? false {
                    if let places = myPlaces.allPlaces {
                        self?.bookmarkedPlaces = places.sorted(by: {
                            let flag1 = $0.place?.isFavourite ?? false == true ? 1 : 0
                            let flag2 = $1.place?.isFavourite ?? false == true ? 1 : 0
                            return flag1 >= flag2
                        })
                        
                        self?._errorMessage = nil
                        handler(.success(true))
                    } else {
                        self?._errorMessage = Message.somethingWentWrong.value
                        handler(.success(false))
                    }
                } else {
                    self?._errorMessage = myPlaces.message
                    handler(.success(false))
                }
                
            case .failure(let error):
                handler(.failure(error))
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
