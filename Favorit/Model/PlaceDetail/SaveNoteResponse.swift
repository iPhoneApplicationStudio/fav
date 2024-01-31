//
//  SaveNoteResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 15/01/24.
//

import Foundation

struct SaveNoteResponse:  Codable {
    let success : Bool?
    let message : String?
    let note: Note?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case note = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        note = try values.decodeIfPresent(Note.self, forKey: .note)
    }
}
