//
//  ComposeNoteViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 15/01/24.
//

import Foundation

protocol ComposeNoteProtocol: AnyObject {
    var errorMessage: String { get }
    
    func saveNote(note: String, handler: @escaping (((Result<Bool, Error>)?) -> Void))
    func addToBookmark(handler: @escaping (((Result<Bool, Error>)?) -> Void))
}

class ComposeNoteViewModel: ComposeNoteProtocol {
    //MARK: Private Properties
    private let networkService = ComposeNoteService()
    private var placeID: String?
    private var _errorMessage: String?
    
    //MARK: Private methods
    required init(placeID: String) {
        self.placeID = placeID
    }
    
    var errorMessage: String {
        return _errorMessage ?? Message.somethingWentWrong.value
    }
    
    func saveNote(note: String, handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let placeID else {
            handler(nil)
            return
        }
        
        let request = SaveNoteRequest(placeID: placeID,
                                      body: SaveNoteRequest.Body(note: note))
        networkService.saveNote(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let isSaved = response.success ?? false
                if isSaved {
                    self?._errorMessage = nil
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                }
                
//                self?._isBookmarked = isBookmarked
                handler(.success(isSaved))
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
                
//                self?._isBookmarked = isBookmarked
                handler(.success(isBookmarked))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func removeToBookmark(handler: @escaping (((Result<Bool, Error>)?) -> Void)) {
        guard let placeID else {
            handler(nil)
            return
        }
        
        let request = RemoveBookmarkRequest(placeID: placeID)
        networkService.removeBookmarkPlace(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let removeBookmarked = response.success ?? false
//                self?._isBookmarked = !removeBookmarked
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
