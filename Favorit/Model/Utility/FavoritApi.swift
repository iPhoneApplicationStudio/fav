//
//  Constant.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

enum FavoritApi {
    case login
    case signup
    case resetPassword
    
    var value: String {
        let serverUrl = FavoritConstant.serverUrl
        switch self {
        case .login:
            return "\(serverUrl)/auth/login"
        case .signup:
            return "\(serverUrl)/auth/register"
        case .resetPassword:
            return "\(serverUrl)/auth/login"
        }
    }
}
