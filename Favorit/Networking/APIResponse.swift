//
//  APIResponse.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Alamofire

public typealias Parameters = [String: Any]

struct APIResponse<T: Decodable>: Decodable {
    let data: T?
    let success: AnyCodable?
    let message: AnyCodable?
}
