//
//  PlaceListService.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

class PlaceListService {
    private let service = NetworkService()
    func getAllRecommendedBookmarks(request: RecommendedBookmarksRequest,
                                    completion: @escaping (Result<BookmarkListResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: BookmarkListResponse.self,
                      isCustom: true,
                      completion: completion)
    }
    
    func getAllMyBookmarks(request: MyBookmarksRequest,
                           completion: @escaping (Result<BookmarkListResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: BookmarkListResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}
