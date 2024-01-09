//
//  PlaceDetailViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import Foundation
import Lightbox

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
    var isPlaceExist: Bool { get }
    var bookmarkCount: Int { get }
    var favouriteCount: Int { get }
    var venue: Place? { get }
    
    init(place: Place?, placeID: String)
    func getAllLightBoxImages() -> [LightboxImage]?
    func getIconUrlStringFor(index: Int) -> String?
    func getPlace(handler: @escaping (((Result<Bool, Error>)?) -> Void))
    func addToBookmark(handler: @escaping (((Result<Bool, Error>)?) -> Void))
    func removeToBookmark(handler: @escaping (((Result<Bool, Error>)?) -> Void))
}

class PlaceDetailViewModel: PlaceDetailProtocol {
    private var place: Place?
    private var placeID: String?
    private let networkService = PlaceDetailService()
    private var _errorMessage: String?
    private var _isBookmarked = false
    
    var venue: Place? {
        return place
    }
    
    let isPlaceExist: Bool
    
    required init(place: Place?, placeID: String) {
        self.place = place
        self._isBookmarked = place?.isBookmarked ?? false
        self.placeID = placeID
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
    
    var bookmarkCount: Int {
        return place?.bookmarkCount ?? 0
    }
    
    var favouriteCount: Int {
        return place?.favouriteCount ?? 0
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
    
    func getAllLightBoxImages() -> [LightboxImage]? {
        guard let place,
              let photos = place.photos,
              photos.count > 0 else {
            return nil
        }
        
        var images = [LightboxImage]()
        for index in 0..<photos.count {
            if let url = URL(string: photos[index]) {
                images.append(LightboxImage(imageURL: url))
            }
        }
        
        return images
    }
    
    func getPlace(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let placeID else {
            handler(nil)
            return
        }
        
        let request = PlaceDetailRequest(placeID: placeID)
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
                self?._errorMessage = nil
                handler(.success(true))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func addToBookmark(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let placeID else {
            handler(nil)
            return
        }
        
        let request = AddBookmarkRequest(placeID: placeID)
        networkService.addBookmarkPlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let isBookmarked = response.success ?? false
                if isBookmarked {
                    self?._errorMessage = nil
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
                self?._isBookmarked = isBookmarked
                handler(.success(isBookmarked))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func removeToBookmark(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let placeID else {
            handler(nil)
            return
        }
        
        let request = RemoveBookmarkRequest(placeID: placeID)
        networkService.removeBookmarkPlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let removeBookmarked = response.success ?? false
                self?._isBookmarked = !removeBookmarked
                if removeBookmarked {
                    self?._errorMessage = nil
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
