//
//  FindPlacesService.swift
//  Favorit
//
//  Created by ONS on 08/12/23.
//

import Foundation

class FindPlacesService {
    private let service = NetworkService()
    func getAllPlaces(request: FindPlacesRequest,
                     completion: @escaping (Result<Places, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: Places.self,
                      isCustom: true,
                      completion: completion)
    }
}
