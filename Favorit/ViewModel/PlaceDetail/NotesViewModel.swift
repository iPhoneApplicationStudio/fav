//
//  NotesViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/01/24.
//

import Foundation

protocol NotesProtocol: AnyObject {
    var numberOfNotes: Int { get }
    var errorMessage: String? { get }
    
    init(placeID: String)
    
    func noteFor(index: Int) -> Note?
    func fetchNotes(handler: @escaping (Result<Bool, Error>) -> Void)
}

class NotesViewModel: NotesProtocol {
    //MARK: Private properties
    private var placeID: String
    private var notes = [Note]()
    private let networkService = NotesService()
    private var _errorMessage: String?
    
    //MARK: INIT
    required init(placeID: String) {
        self.placeID = placeID
    }
    
    //MARK: properties
    var numberOfNotes: Int {
        return notes.count
    }
    
    var errorMessage: String? {
        return _errorMessage
    }
    
    //MARK: methods
    func noteFor(index: Int) -> Note? {
        guard index >= 0,
              index < notes.count else {
            return nil
        }
        
        return notes[index]
    }
    
    func fetchNotes(handler: @escaping (Result<Bool, Error>) -> Void) {
        let request = NotesRequest(placeID: placeID)
        networkService.fetchNotes(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                guard let notes = response.notes else {
                    self?._errorMessage = response.message
                    handler(.success(false))
                    return
                }
                
                self?.notes = notes
                self?._errorMessage = nil
                handler(.success(true))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
