//
//  AddNewFollowing.swift
//  Favorit
//
//  Created by ONS on 07/12/23.
//

import Foundation

protocol FindUsersProtocol: AnyObject {
    var numberOfItems: Int { get }
    var numberOfSection: Int { get }
    var pageTitle: String { get }
    var searchTitle: String { get }
    var currentPage: Int { get set }
    var totalUsers: Int { get }
    
    func getItemFor(index: Int) -> User?
    func searchUser(text: String?,
                    handler: @escaping (((Result<Bool, APIError>)?) -> Void?))
}

class FindUsersViewModel: FindUsersProtocol {
    private var users = [User]()
    private let itemsPerPage = 10
    private var _currentPage = 1
    private let sortOrder = "asc"
    
    var totalUsers = 0
    private let networkService = FindUsersService()
    
    var pageTitle: String {
        return "Find User"
    }
    
    var searchTitle: String {
        return "Search User"
    }
    
    var currentPage: Int {
        get {
            return _currentPage
        } set {
            _currentPage = newValue
        }
    }
    
    var numberOfSection: Int {
        return 2
    }
    
    var numberOfItems: Int {
        return users.count
    }
    
    func getItemFor(index: Int) -> User? {
        guard index >= 0,
              index < users.count else {
            return nil
        }
        
        return users[index]
    }
    
    func searchUser(text: String?,
                    handler: @escaping (((Result<Bool, APIError>)?) -> Void?)) {
        guard let text else {
            handler(nil)
            return
        }
        
        if _currentPage == 1 {
            self.users.removeAll()
        }
        
        let request = FindUsersRequest(queryParams: FindUsersRequest.RequestParams(search: text,
                                                                                 page: currentPage,
                                                                                 limit: itemsPerPage,
                                                                                 sortOrder: sortOrder))
        networkService.getAllUsers(request: request) {[weak self] result in
            switch result {
            case .success(let success):
                self?.users += success.data ?? []
                self?.currentPage += 1
                self?.totalUsers = success.meta?.total?.integer ?? 0
                handler(.success(true))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
