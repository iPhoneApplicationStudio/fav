//
//  FeedService.swift
//  Favorit
//
//  Created by Abhinay Maurya on 02/02/24.
//

import Foundation

class FeedService {
    private let service = NetworkService()
    func getAllFeeds(request: FeedRequest,
                     completion: @escaping (Result<FeedResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: FeedResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}
