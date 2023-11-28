//
//  Following.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

struct Following: UserProtocol, Codable {
    var id : String
    var name : String
    var email : String
    var followers: Int
    var following: Int
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case followers
        case following
        case avatar
    }
}

let __followings = [Following(id: "1", name: "Abhinay Kumar", email: "abhi@gmail.com", followers: 2, following: 3),
                    Following(id: "2", name: "Maurya Kumar", email: "maurya@gmail.com", followers: 5, following: 7)]
