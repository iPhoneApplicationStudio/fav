//
//  UserFollowedResponse.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation

struct UserFollowedResponse: Decodable {
    let data: UserFollowedData?
    let success: Bool
    let message: String?
}

struct UserFollowedData: Decodable {
    let creator: String?
    let user: String?
    let active: Bool?
    let _id: String?
    let createdAt: String?
    let updatedAt: String?
}
