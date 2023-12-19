//
//  PlaceListViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

enum PlaceType: Int {
    case myPlaces = 0
    case recommendedPlaces = 1
    case allPlaces = 2
}

enum PlaceViewType {
    case list
    case map
}


protocol PlaceListProtocol: AnyObject {
    var allMyPlaces: [BookmarkDetail]? { get }
    var allRecommendedBookmarkedPlaces: [BookmarkDetail]? { get }
    var allPlaces: [BookmarkDetail]? { get }
    var errorMessage: String? { get }
    
    func getItemFor(index: Int, for: PlaceType) -> BookmarkDetail?
    func getMyBookmarks(handler: @escaping (((Result<Bool, Error>)?) -> Void))
    func getAllRecommendedBookmarks(handler: @escaping (((Result<Bool, Error>)?) -> Void))
}

class PlaceListViewModel: PlaceListProtocol {
    private var myBookmarkedPlaces = [BookmarkDetail]()
    private var recommendedBookmarkedPlaces = [BookmarkDetail]()
    private var _allPlaces = [BookmarkDetail]()
    private let networkService = PlaceListService()
    private let userID: String?
    private var _errorMessage: String?
    
    init(userID: String) {
        self.userID = userID
    }
    
    var allMyPlaces: [BookmarkDetail]? {
        myBookmarkedPlaces
    }
    
    var allRecommendedBookmarkedPlaces: [BookmarkDetail]? {
        recommendedBookmarkedPlaces
    }
    
    var allPlaces: [BookmarkDetail]? {
        _allPlaces
    }
    
    var errorMessage: String? {
        return _errorMessage
    }
    
    func getItemFor(index: Int, 
                    for type: PlaceType) -> BookmarkDetail? {
        guard index >= 0 else {
            return nil
        }
        
        var places = [BookmarkDetail]()
        switch type {
        case .myPlaces:
            places = myBookmarkedPlaces
        case .recommendedPlaces:
            places = recommendedBookmarkedPlaces
        case .allPlaces:
            places = _allPlaces
        }
        
        guard index < places.count else {
            return nil
        }
        
        return places[index]
    }
    
    //GET My Bookmarks
    func getMyBookmarks(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let userID else {
            handler(nil)
            return
        }
        
        let request = MyBookmarksRequest(userID: userID)
        networkService.getAllMyBookmarks(request: request) {[weak self] result in
            self?.myBookmarkedPlaces.removeAll()
            switch result {
            case .success(let myPlaces):
                if myPlaces.success ?? false {
                    if let allBookmarks = myPlaces.allBookmarks {
                        self?.myBookmarkedPlaces = allBookmarks
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
    
    //GET Recommended Bookmarks
    func getAllRecommendedBookmarks(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let userID else {
            handler(nil)
            return
        }
        
        let request = RecommendedBookmarksRequest(userID: userID)
        networkService.getAllRecommendedBookmarks(request: request) {[weak self] result in
            self?.recommendedBookmarkedPlaces.removeAll()
            switch result {
            case .success(let recommendedPlaces):
                if recommendedPlaces.success ?? false {
                    if let allBookmarks = recommendedPlaces.allBookmarks {
                        self?.recommendedBookmarkedPlaces = allBookmarks
                        self?._errorMessage = nil
                        handler(.success(true))
                    } else {
                        self?._errorMessage = Message.somethingWentWrong.value
                        handler(.success(false))
                    }
                } else {
                    self?._errorMessage = recommendedPlaces.message
                    handler(.success(false))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
