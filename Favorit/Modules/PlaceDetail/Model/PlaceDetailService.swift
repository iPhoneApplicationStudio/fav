//
//  PlaceDetailService.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import Foundation

class PlaceDetailService {
    private let service = NetworkService()
    func getPlace(request: PlaceDetailRequest,
                  completion: @escaping (Result<SinglePlace, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: SinglePlace.self,
                      isCustom: true,
                      completion: completion)
    }
    
    func addFavouritePlace(request: AddFavouriteRequest,
                           completion: @escaping (Result<FavouriteResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: FavouriteResponse.self,
                      isCustom: true,
                      completion: completion)
    }
    
    func removeFavouritePlace(request: RemoveFavouriteRequest,
                              completion: @escaping (Result<FavouriteResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: FavouriteResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}
