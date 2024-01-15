//
//  PlaceDetailViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import Foundation

protocol PlaceDetailProtocol: AnyObject {
    var placeName: String? { get }
    var category: String? { get }
    var featuredPhotoURL: String? { get }
    var formattedAddress: String? { get }
    var address: String? { get }
    var distance: String? { get }
    var numnerOfIcons: Int { get }
    var errorMessage: String? { get }
    var isBookmarked: Bool { get set }
    var isFavourite: Bool { get }
    var isPlaceExist: Bool { get }
    var bookmarkCount: Int { get }
    var favouriteCount: Int { get }
    var venue: Place? { get }
    var placeID: String? { get }
    var photoURLs: [String]? { get }
    
    init(place: Place?, placeID: String)
    
    func getIconUrlStringFor(index: Int) -> String?
    func getPlace(handler: @escaping (((Result<Bool, Error>)?) -> Void))
    func toggleVenueFromFavouriteList(handler: @escaping (((Result<Bool, Error>)?) -> Void))
}

class PlaceDetailViewModel: PlaceDetailProtocol {
    private var place: Place?
    private var _placeID: String?
    private let networkService = PlaceDetailService()
    private var _errorMessage: String?
    private var _isBookmarked = false
    private var _isFavourite = false
    
    var venue: Place? {
        return place
    }
    
    var placeID: String? {
        return place?.placeId ?? _placeID
    }
    
    let isPlaceExist: Bool
    
    required init(place: Place?, placeID: String) {
        self.place = place
        self._isBookmarked = place?.isBookmarked ?? false
        self._isFavourite = place?.isFavourite ?? false
        self._placeID = placeID
        self.isPlaceExist = place != nil
    }
    
    var placeName: String? {
        return place?.name
    }
    
    var category: String? {
        return place?.categories?.first?.name
    }
    
    var featuredPhotoURL: String? {
        return place?.featurePhotoURL
    }
    
    var formattedAddress: String? {
        return place?.location?.formattedAddress ?? place?.location?.address
    }
    
    var address: String? {
        return place?.location?.address ?? place?.location?.formattedAddress
    }
    
    var distance: String? {
        return place?.distanceString
    }
    
    var errorMessage: String? {
        return _errorMessage
    }
    
    var numnerOfIcons: Int {
        return place?.photos?.count ?? 0
    }
    
    var isBookmarked: Bool {
        get {
            _isBookmarked
        } set {
            _isBookmarked = newValue
        }
    }
    
    var isFavourite: Bool {
        _isFavourite
    }
    
    var bookmarkCount: Int {
        return place?.bookmarkCount ?? 0
    }
    
    var favouriteCount: Int {
        return place?.favouriteCount ?? 0
    }
    
    var photoURLs: [String]? {
        return place?.photos
    }
    
    func getIconUrlStringFor(index: Int) -> String? {
        guard let place,
              let photos = place.photos,
              index >= 0,
              index < photos.count else {
            return nil
        }
        
        return photos[index]
    }
    
    func getPlace(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let _placeID else {
            handler(nil)
            return
        }
        
        let request = PlaceDetailRequest(placeID: _placeID)
        networkService.getPlace(request: request) {[weak self] result in
            switch result {
            case .success(let singlePlace):
                guard let place = singlePlace.place else {
                    self?._errorMessage = singlePlace.message
                    handler(.success(false))
                    return
                }
                
                let distance =  self?.place?.distance
                self?.place = place
                self?.place?.distance = distance
                self?._isBookmarked = place.isBookmarked
                self?._isFavourite = place.isFavourite
                self?._errorMessage = nil
                handler(.success(true))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func toggleVenueFromFavouriteList(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        _isFavourite ? self.removeFromFavourite(handler: handler) : self.addToFavourite(handler: handler)
    }
    
    private func addToFavourite(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let _placeID else {
            handler(nil)
            return
        }
        
        let request = AddFavouriteRequest(placeID: _placeID)
        networkService.addFavouritePlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let isFavourite = response.success ?? false
                if isFavourite {
                    self?._errorMessage = nil
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                self?._isFavourite = isFavourite
                handler(.success(isFavourite))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func removeFromFavourite(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let _placeID else {
            handler(nil)
            return
        }
        
        let request = RemoveFavouriteRequest(placeID: _placeID)
        networkService.removeFavouritePlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let removeFavrouite = response.success ?? false
                self?._isFavourite = !removeFavrouite
                if removeFavrouite {
                    self?._errorMessage = nil
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                handler(.success(removeFavrouite))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
