//
//  User.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

protocol UserProtocol {
    var id : String { get set }
    var name : String { get set }
    var email : String { get set }
    var followers: Int { get set }
    var following: Int { get set }
    var avatar: String? { get set }
}
