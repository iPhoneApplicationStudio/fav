//
//  NoteResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/01/24.
//

import Foundation

struct NotesResponse:  Codable {
    let success : Bool?
    let message : String?
    let notes : [Note]?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case notes = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notes = try values.decodeIfPresent([Note].self, forKey: .notes)
    }
}
