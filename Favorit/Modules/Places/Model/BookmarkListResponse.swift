//
//  PlaceListResponse.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

struct BookmarkListResponse: Codable {
    let success : Bool?
    let message : String?
    let allBookmarks : [BookmarkDetail]?

    enum CodingKeys: String, CodingKey {
        case success, message
        case allBookmarks = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        allBookmarks = try values.decodeIfPresent([BookmarkDetail].self, forKey: .allBookmarks)
    }
}
