//
//  SignUpResponse.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

struct SignUpResponse: Decodable {
    let id: String?
    let name: String?
    let email: String?
    let city: String?
    let country: String?
    let avatar: String?
    let followers: AnyCodable?
    let following: AnyCodable?
    let isActive: AnyCodable?
    let createdAt: AnyCodable?
    let updatedAt: AnyCodable?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, city, country, avatar, followers, following
        case isActive = "active"
        case createdAt, updatedAt, token
    }
}
