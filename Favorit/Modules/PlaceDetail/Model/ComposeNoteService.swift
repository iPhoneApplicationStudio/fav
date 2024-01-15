//
//  ComposeNoteService.swift
//  Favorit
//
//  Created by Abhinay Maurya on 15/01/24.
//

import Foundation

class ComposeNoteService {
    private let service = NetworkService()
    
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
    
    func saveNote(request: SaveNoteRequest,
                  completion: @escaping (Result<SaveNoteResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: SaveNoteResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}
