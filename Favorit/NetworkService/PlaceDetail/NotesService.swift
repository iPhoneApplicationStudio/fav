//
//  NotesDetailService.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/01/24.
//

import Foundation

class NotesService {
    private let service = NetworkService()
    
    func fetchNotes(request: NotesRequest,
                    completion: @escaping (Result<NotesResponse, APIError>) -> Void) {
        service.fetch(apiEndPoint: request,
                      model: NotesResponse.self,
                      isCustom: true,
                      completion: completion)
    }
}

