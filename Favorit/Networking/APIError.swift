//
//  APIError.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

enum APIError: Error {
    case accessTokenExpired
    case refreshTokenExpired
    case noData
    case requestTimeout
    case unableToDecode(decodingError: Error)
    case requestFailure(error: Error)
    case domainError(message: String)
}
