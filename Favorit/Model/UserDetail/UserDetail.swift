//
//  UserDetail.swift
//  Favorit
//
//  Created by Abhinay Maurya on 19/12/23.
//

import Foundation

struct UserDetail: Decodable {
    let data: User?
    let success: Bool
    let message: String?
}
