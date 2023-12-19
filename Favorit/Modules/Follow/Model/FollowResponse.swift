//
//  FollowersResponse.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

struct FollowResponse: Codable {
    let success : Bool?
    let message : String?
    let allUsersData : [FollowData]?

    enum CodingKeys: String, CodingKey {
        case success, message
        case allUsersData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        allUsersData = try values.decodeIfPresent([FollowData].self, forKey: .allUsersData)
    }
}

struct FollowData: Codable {
    let id: String?
    let creator: String?
    let user: User?
    let active: Bool?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case creator
        case active
        case createdAt
        case updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        creator = try values.decodeIfPresent(String.self, forKey: .creator)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        
        user = try values.decodeIfPresent(User.self, forKey: .user)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
    }
}

struct FollowingResponse: Codable {
    let success : Bool?
    let message : String?
    let allUsersData : [FollowingData]?

    enum CodingKeys: String, CodingKey {
        case success, message
        case allUsersData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        allUsersData = try values.decodeIfPresent([FollowingData].self, forKey: .allUsersData)
    }
}

struct FollowingData: Codable {
    let id: String?
    let creator: String?
    let user: User?
    let active: Bool?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user = "creator"
        case creator = "user"
        case active
        case createdAt
        case updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        creator = try values.decodeIfPresent(String.self, forKey: .creator)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        
        user = try values.decodeIfPresent(User.self, forKey: .user)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
    }
}

