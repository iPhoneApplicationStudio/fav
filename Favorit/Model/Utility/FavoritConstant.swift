//
//  FavoritConstant.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

class FavoritConstant {
    private let isProdEnable = false
    private let prodUrl = ""
    private let devUrl = ""
    
    static let shared = FavoritConstant()
    private init() { }
    
    class var serverUrl: String {
        return FavoritConstant.shared.isProdEnable ? FavoritConstant.shared.prodUrl : FavoritConstant.shared.devUrl
    }
    
    class var headers: [String: String] {
        
        return [:]
    }
}

