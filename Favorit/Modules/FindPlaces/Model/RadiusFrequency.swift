//
//  RadiusFrequency.swift
//  Favorit
//
//  Created by Abhinay Maurya on 02/01/24.
//

import Foundation

enum RadiusFrequency: String, CaseIterable {
    case nearBy = "Any Distance"
    case point25Mile = ".25 miles"
    case point5Mile = ".50 miles"
    case oneMile = "1 mile"
    case fiveMile = "5 miles"
    
    var title: String {
        return rawValue
    }
    
    var value: Int {
        switch self {
        case .nearBy:
            return 805
        case .point25Mile:
            return 402
        case .point5Mile:
            return 805
        case .oneMile:
            return 1610
        case .fiveMile:
            return 8046
        }
    }
}
