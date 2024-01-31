//
//  User.swift
//  Favorit
//
//  Created by Abhinay Maurya on 12/12/23.
//

import Foundation

struct PlaceUser : Codable {
    let id : String
    let name : String?
    let email : String?
    let followers: Int?
    let following: Int?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case email = "email"
        case followers = "followers"
        case following = "following"
        case avatar = "avatar"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        followers = try values.decodeIfPresent(Int.self, forKey: .followers)
        following = try values.decodeIfPresent(Int.self, forKey: .following)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
    }
}

