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
    var allMyBookmarkedPlaces: [PlaceDetail]? { get }
    var allMyFavouritePlaces: [PlaceDetail]? { get }
    var allMyPlacesCount: Int { get }
    var allMyPlaces: [PlaceDetail]? { get }
    var allRecommendedBookmarkedPlaces: [PlaceDetail]? { get }
    var allPlaces: [PlaceDetail]? { get }
    var errorMessage: String { get }
    
    func getItemFor(index: Int, for: PlaceType, section: Int) -> PlaceDetail?
    func getMyBookmarks(handler: @escaping (Result<Bool, Error>) -> Void)
    func getMyFavourites(handler: @escaping (Result<Bool, Error>) -> Void)
    func getAllRecommendedBookmarks(handler: @escaping ((Result<Bool, Error>)) -> Void)
    func removeBookmarkFor(index: Int, handler: @escaping (Result<Bool, Error>) -> Void)
    func removeFavouriteFor(index: Int, handler: @escaping (Result<Bool, Error>) -> Void)
}

class PlaceListViewModel: PlaceListProtocol {
    private var myBookmarkedPlaces = [PlaceDetail]()
    private var myFavouritePlaces = [PlaceDetail]()
    private var recommendedBookmarkedPlaces = [PlaceDetail]()
    private var _allPlaces = [PlaceDetail]()
    private let networkService = PlaceListService()
    private let placeService = PlaceDetailService()
    private let userID: String
    private var _errorMessage: String?
    
    init(userID: String) {
        self.userID = userID
    }
    
    var allMyBookmarkedPlaces: [PlaceDetail]? {
        myBookmarkedPlaces
    }
    
    var allMyFavouritePlaces: [PlaceDetail]? {
        myFavouritePlaces
    }
    
    var allMyPlacesCount: Int {
        let count = myFavouritePlaces.count + myBookmarkedPlaces.count
        return count
    }
    
    var allMyPlaces: [PlaceDetail]? {
        let places = myFavouritePlaces + myBookmarkedPlaces
        return places
    }
    
    var allRecommendedBookmarkedPlaces: [PlaceDetail]? {
        recommendedBookmarkedPlaces
    }
    
    var allPlaces: [PlaceDetail]? {
        _allPlaces
    }
    
    var errorMessage: String {
        return _errorMessage ?? Message.somethingWentWrong.value
    }
    
    func getItemFor(index: Int, 
                    for type: PlaceType,
                    section: Int = 0) -> PlaceDetail? {
        guard index >= 0 else {
            return nil
        }
        
        var places = [PlaceDetail]()
        switch type {
        case .myPlaces:
            if section == 0 {
                places = myFavouritePlaces
            } else {
                places = myBookmarkedPlaces
            }
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
    func getMyBookmarks(handler: @escaping (Result<Bool, Error>) -> Void) {
        let request = MyBookmarksRequest(userID: userID)
        networkService.getAllMyBookmarks(request: request) {[weak self] result in
            self?.myBookmarkedPlaces.removeAll()
            switch result {
            case .success(let myPlaces):
                if myPlaces.success ?? false {
                    if let places = myPlaces.allPlaces {
                        self?.myBookmarkedPlaces = places.sorted(by: { $0.place?.name ?? "" < $1.place?.name ?? "" })
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
    
    //GET Favourites
    func getMyFavourites(handler: @escaping (Result<Bool, Error>) -> Void) {
        let request = AllFavouriteRequest(userID: userID)
        networkService.getAllFavourites(request: request) {[weak self] result in
            self?.myFavouritePlaces.removeAll()
            switch result {
            case .success(let myPlaces):
                if myPlaces.success ?? false {
                    if let places = myPlaces.allPlaces {
                        self?.myFavouritePlaces = places.sorted(by: { $0.place?.name ?? "" < $1.place?.name ?? "" })
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
    func getAllRecommendedBookmarks(handler: @escaping (Result<Bool, Error>) -> Void) {
        let request = RecommendedBookmarksRequest(userID: userID)
        networkService.getAllRecommendedBookmarks(request: request) {[weak self] result in
            self?.recommendedBookmarkedPlaces.removeAll()
            switch result {
            case .success(let recommendedPlaces):
                if recommendedPlaces.success ?? false {
                    if let places = recommendedPlaces.allPlaces {
                        self?.recommendedBookmarkedPlaces = places
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
    
    //Remove Favourite
    func removeFavouriteFor(index: Int, handler: @escaping (Result<Bool, Error>) -> Void) {
        guard index >= 0, index < myFavouritePlaces.count,
              let placeID = myFavouritePlaces[index].place?.placeId else {
            handler(.failure(NetworkError.somethingWentWrong))
            return
        }
        
        let request = RemoveFavouriteRequest(placeID: placeID)
        placeService.removeFavouritePlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let removeFavourite = response.success ?? false
                if removeFavourite {
                    self?._errorMessage = nil
                    self?.myFavouritePlaces.remove(at: index)
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                handler(.success(removeFavourite))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    //Remove Bookmark
    func removeBookmarkFor(index: Int,
                        handler: @escaping (Result<Bool, Error>) -> Void) {
        guard index >= 0, index < myBookmarkedPlaces.count,
              let placeID = myBookmarkedPlaces[index].place?.placeId else {
            handler(.failure(NetworkError.somethingWentWrong))
            return
        }
        
        let request = RemoveBookmarkRequest(placeID: placeID)
        placeService.removeBookmarkPlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let removeBookmarked = response.success ?? false
                if removeBookmarked {
                    self?._errorMessage = nil
                    self?.myBookmarkedPlaces.remove(at: index)
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                handler(.success(removeBookmarked))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
