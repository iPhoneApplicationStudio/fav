//
//  LoginResponse.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

struct LoginResponse : Decodable {
    let success : Bool
    let message : String?
    let data : LoginData?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LoginData.self, forKey: .data)
    }
}

struct LoginData : Codable {
    let id : String?
    let name : String?
    let email : String?
    let city : String?
    let country : String?
    let avatar : String?
    let followers : Int?
    let following : Int?
    let active : Bool?
    let createdAt : String?
    let updatedAt : String?
    let token : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
        case email = "email"
        case city = "city"
        case country = "country"
        case avatar = "avatar"
        case followers = "followers"
        case following = "following"
        case active = "active"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        followers = try values.decodeIfPresent(Int.self, forKey: .followers)
        following = try values.decodeIfPresent(Int.self, forKey: .following)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}

