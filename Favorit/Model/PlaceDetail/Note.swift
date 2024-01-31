//
//  TipRecord.swift
//  Favorit
//
//  Created by Abhinay Maurya on 07/01/24.
//

import Foundation

struct Note: Codable {
    let id: String
    let note: String?
    let user: User?
    let placeID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case note
        case user
        case placeID = "place"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        placeID = try values.decodeIfPresent(String.self, forKey: .placeID)
        if let user = try? values.decodeIfPresent(User.self, forKey: .user) {
            self.user = user
        } else {
            self.user = nil
        }
    }
    
    init(id: String) {
        self.id = id
        self.note = nil
        self.user = nil
        self.placeID = nil
    }
}
