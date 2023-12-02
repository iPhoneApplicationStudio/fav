//
//  User.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

struct UserPage: Decodable {
    
    struct Page: Decodable {
        let page: AnyCodable?
        let limit: AnyCodable?
        let total: AnyCodable?
    }
    
    let data: [User]?
    let success: AnyCodable?
    let message: AnyCodable?
    let meta: Page?
}

struct User: Decodable {
    let _id: String?
    let name: String?
    let email: String?
    let city: String?
    let country: String?
    let avatar: String?
    let followers: AnyCodable?
    let following: AnyCodable?
    let active: AnyCodable?
    let createdAt: String?
    let updatedAt: String?
}
