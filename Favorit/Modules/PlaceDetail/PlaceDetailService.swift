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
    
    func addBookmarkPlace(request: AddBookmarkRequest,
                  completion: @escaping (Result<BookmarkResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: BookmarkResponse.self,
                      isCustom: true,
                      completion: completion)
    }
    
    func removeBookmarkPlace(request: RemoveBookmarkRequest,
                  completion: @escaping (Result<BookmarkResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: BookmarkResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}
