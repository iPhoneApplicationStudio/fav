//
//  ComposeNoteViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 15/01/24.
//

import Foundation

protocol ComposeNoteProtocol: AnyObject {
    var errorMessage: String { get }
    var currentNote: Note? { get }
    var placeName: String { get }
    var isNoteExist: Bool { get }
    
    func addToBookmark(handler: @escaping (Result<Bool, Error>) -> Void)
    func saveNote(noteString: String,
                  handler: @escaping (Result<Note, Error>) -> Void)
}

class ComposeNoteViewModel: ComposeNoteProtocol {
    //MARK: Private Properties
    private let networkService = ComposeNoteService()
    private let placeID: String
    private let venueName: String
    private var _errorMessage: String?
    private var note: Note?
    
    //MARK: Private methods
    required init(placeID: String,
                  placeName: String,
                  existingNote: Note?) {
        self.placeID = placeID
        self.note = existingNote
        self.venueName = placeName
    }
    
    var placeName: String {
        return venueName
    }
    
    var errorMessage: String {
        return _errorMessage ?? Message.somethingWentWrong.value
    }
    
    var currentNote: Note? {
        return note
    }
    
    var isNoteExist: Bool {
        return note != nil
    }
    
    func saveNote(noteString: String,
                  handler: @escaping (Result<Note, Error>)  -> Void) {
        if let note = self.note {
            self.updateNote(noteString: noteString,
                            noteID: note.id,
                            handler: handler)
        } else {
            let request = SaveNoteRequest(placeID: placeID,
                                          body: SaveNoteRequest.Body(note: noteString))
            networkService.saveNote(request: request) {[weak self] result in
                switch result {
                case .success(let response):
                    let isSaved = response.success ?? false
                    if isSaved, let note = response.note {
                        self?._errorMessage = nil
                        handler(.success(note))
                    } else {
                        self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                        handler(.failure(NetworkError.somethingWentWrong))
                    }
                    
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }
    
    private func updateNote(noteString: String,
                            noteID: String,
                            handler: @escaping (Result<Note, Error>) -> Void) {
        let request = UpdateNoteRequest(noteID: noteID,
                                        body: UpdateNoteRequest.Body(note: noteString))
        networkService.updateNote(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let isSaved = response.success ?? false
                if isSaved, let note = response.note {
                    self?._errorMessage = nil
                    handler(.success(note))
                } else {
                    self?._errorMessage = response.message ?? Message.somethingWentWrong.value
                    handler(.failure(NetworkError.somethingWentWrong))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func addToBookmark(handler: @escaping (Result<Bool, Error>) -> Void) {
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
                
                handler(.success(isBookmarked))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
