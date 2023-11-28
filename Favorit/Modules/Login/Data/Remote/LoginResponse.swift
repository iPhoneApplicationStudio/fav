//
//  LoginResponse.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

struct LoginResponse: Decodable {

    let id: String?
    let name: String?
    let email: String?
    let city: String?
    let country: String?
    let avatar: String?
    let followers: Int?
    let following: Int?
    let active: Bool?
    let createdAt: String?
    let updatedAt: String?
    let token: String?

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
}

