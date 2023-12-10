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
    let success: Bool
    let message: String?
    let meta: Page?
}

struct User: Decodable {
    let _id: String?
    let name: String?
    let email: String?
    let active: Bool
    let createdAt: String?
    let updatedAt: String?
    let bookmarkCount: Int
    let followerCount: Int
    let favouriteCount: Int
    let followingCount: Int?
    let followed: Bool
    let avatar: String?
}
