//
//  APIEndpoint.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Alamofire

protocol APIEndpoint {
    
    var baseURL: String { get }
    var urlString: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Encodable? { get }
    var headers: HTTPHeaders? { get }
    var paramenterEncoding: ParameterEncoder { get }
    
}

extension APIEndpoint {
    
    var baseURL: String {
        return FavoritConstant.serverUrl
    }
    
    var headers: HTTPHeaders? {
        var headers: HTTPHeaders = [:]
        if let tokenKey = UserDefaults.accessTokenKey,
            let token = KeychainManager.retrieve(for: tokenKey) {
            headers["Authorization"] = token
        }
        return headers
    }
    
    var paramenterEncoding: ParameterEncoder {
        switch httpMethod {
        case .post, .put, .patch:
            return JSONParameterEncoder.default
        default:
            return URLEncodedFormParameterEncoder.default
        }
    }
}
