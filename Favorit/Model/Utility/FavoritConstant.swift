//
//  FavoritConstant.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

class FavoritConstant {
    private let isProdEnable = false
    private let prodUrl = "http://103.107.184.159:8000/api/v1"
    private let devUrl = "http://103.107.184.159:8000/api/v1"
    
    static let shared = FavoritConstant()
    private init() { }
    
    class var serverUrl: String {
        return FavoritConstant.shared.isProdEnable ? FavoritConstant.shared.prodUrl : FavoritConstant.shared.devUrl
    }
    
    class var headers: [String: String] {
        
        return [:]
    }
}

