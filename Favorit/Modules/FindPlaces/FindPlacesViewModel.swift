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
    var errorMessage: String? { get }
    
    func itemForIndex(_ index: Int) -> SearchedPlace?
    func getAllPlacesFor(text: String?, handler: @escaping (((Result<Bool, Error>)?) -> Void))
}

class FindPlacesViewModel: FindPlacesProtocol {
    private let sort = "DISTANCE"
    private let openNow = "true"
    private var allPlaces = [SearchedPlace]()
    private let networkService = FindPlacesService()
    private let locationService = LocationService.sharedInstance
    private var _errorMessage: String?
    
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
    
    func itemForIndex(_ index: Int) -> SearchedPlace? {
        guard index >= 0,
              index < allPlaces.count else {
            return nil
        }
        
        return allPlaces[index]
    }
    
    func getAllPlacesFor(text: String?,
                         handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let text,
              let currentLocation = locationService.currentLocation else {
            handler(nil)
            return
        }
        
        let latLongStr = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        let request = FindPlacesRequest(queryParams: FindPlacesRequest.RequestParams(query: text,
                                                                                     latLong: latLongStr,
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
