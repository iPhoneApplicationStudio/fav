//
//  FeedActivityViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 15/12/23.
//

import Foundation

protocol FeedActivityProtocol: AnyObject {
    init(userID: String)
    func fetchData(handler: @escaping (Result<Bool, Error>) -> Void)
}

class FeedActivityViewModel: FeedActivityProtocol {
    //MARK: Private properties
    private let userID: String
    private let networkService = FeedService()
    
    required init(userID: String) {
        self.userID = userID
    }
    
    func fetchData(handler: @escaping (Result<Bool, Error>) -> Void) {
        let request = FeedRequest(userID: userID)
        networkService.getAllFeeds(request: request) {[weak self] result in
            switch result {
            case .success(let response):
//                if let allPlaces = response.allPlaces {
//                    self?.allPlaces = allPlaces
//                    self?._errorMessage = nil
//                    handler(.success(true))
//                } else {
//                    self?._errorMessage = searchedPlaces.message
//                    handler(.success(false))
//                }
                handler(.success(true))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
