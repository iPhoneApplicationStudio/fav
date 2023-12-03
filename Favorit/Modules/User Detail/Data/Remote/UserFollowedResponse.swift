//
//  UserFollowedResponse.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation

struct UserFollowedResponse: Decodable {
    let creator: String?
    let user: String?
    let active: AnyCodable?
    let _id: String?
    let createdAt: String?
    let updatedAt: String?
}
