//
//  FindPlacesViewModel.swift
//  Favorit
//
//  Created by ONS on 08/12/23.
//

import Foundation
protocol FindPlacesProtocol: AnyObject {
    var numberOfItems: Int { get }
    var pageTitle: String { get }
    var searchTitle: String { get }
    var radius: RadiusFrequency { get set }
    var selectedSubCategories: [String] { get set }
    var errorMessage: String? { get }
    
    func updateFavouriteState(state: Bool, placeID: String)
    func updateBookmarkState(state: Bool, placeID: String)
    
    func itemForIndex(_ index: Int) -> Place?
    func getAllPlacesFor(text: String?,
                         handler: @escaping (((Result<Bool, Error>)?) -> Void))
}

class FindPlacesViewModel: FindPlacesProtocol {
    private let sort = "DISTANCE"
    private let openNow = "true"
    //private let categories = 13000
    private let limit = 50
    private var allPlaces = [Place]()
    private let networkService = FindPlacesService()
    private let locationService = LocationService.shared
    private var _errorMessage: String?
    private var _radius: RadiusFrequency = FavoritConstant.defaultFrequency
    
    init(radius: RadiusFrequency) {
        self._radius = radius
    }
    
    var pageTitle: String {
        return "Search Place"
    }
    
    var searchTitle: String {
        return "Find Venues"
    }
    
    var numberOfItems: Int {
        return allPlaces.count
    }
    
    var errorMessage: String? {
        return _errorMessage
    }
    
    var radius: RadiusFrequency {
        get {
            _radius
        } set {
            _radius = newValue
        }
    }
    
    var selectedSubCategories: [String] = ["restaurant"]//Default
    
    func itemForIndex(_ index: Int) -> Place? {
        guard index >= 0,
              index < allPlaces.count else {
            return nil
        }
        
        return allPlaces[index]
    }
    
    func updateFavouriteState(state: Bool, placeID: String) {
        var index: Int?
        var place: Place?
        for (i, venue) in allPlaces.enumerated() {
            if venue.placeId == placeID {
                place = venue
                place?.isFavourite = state
                index = i
                break
            }
        }
        
        guard let index,
              let place else {
            return
        }
        
        allPlaces[index] = place
    }
    
    func updateBookmarkState(state: Bool, placeID: String) {
        var index: Int?
        var place: Place?
        for (i, venue) in allPlaces.enumerated() {
            if venue.placeId == placeID {
                place = venue
                place?.isBookmarked = state
                index = i
                break
            }
        }
        
        guard let index,
              let place else {
            return
        }
        
        allPlaces[index] = place
    }
    
    func getAllPlacesFor(text: String?,
                         handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let currentLocation = locationService.currentLocation else {
            handler(nil)
            return
        }
        
        let categories = selectedSubCategories.joined(separator: ",")
        let latLongStr = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        let request = FindPlacesRequest(queryParams: FindPlacesRequest.RequestParams(query: text,
                                                                                     limit: limit,
                                                                                     latLong: latLongStr,
                                                                                     categories: categories,
                                                                                     radius: _radius.value,
                                                                                     openNow: openNow,
                                                                                     sort: sort))
        networkService.getAllPlaces(request: request) {[weak self] result in
            self?.allPlaces.removeAll()
            switch result {
            case .success(let searchedPlaces):
                if let allPlaces = searchedPlaces.allPlaces {
                    self?.allPlaces = allPlaces
                    self?._errorMessage = nil
                    handler(.success(true))
                } else {
                    self?._errorMessage = searchedPlaces.message
                    handler(.success(false))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
