//
//  FollowersResponse.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation


struct FollowersResponse: Decodable {
    
    typealias Creator = User
    
    struct User: Decodable {
        let id: String?
        let name: String?
        let email: String?
        let followers: AnyCodable?
        let following: AnyCodable?
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
            case email
            case followers
            case following
        }
    }
    
    let id: String?
    let creator: Creator?
    let user: User?
    let active: AnyCodable?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case creator, user, active, createdAt, updatedAt
    }
}
