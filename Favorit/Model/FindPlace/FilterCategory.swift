//
//  FilterCategory.swift
//  Favorit
//
//  Created by Abhinay Maurya on 06/01/24.
//

import Foundation

enum FilterCategoryKeys: CaseIterable {
    case resturant
    case bar
    case breakfast
    case cafe
    case dessert
    
    var title: String {
        switch self {
        case .resturant:
            return "Restaurants"
        case .bar:
            return "Bars"
        case .breakfast:
            return "Breakfast"
        case .cafe:
            return "Coffee/Tea"
        case .dessert:
            return "Dessert"
        }
    }
    
    var key: String {
        switch self {
        case .resturant:
            return "restaurant"
        case .bar:
            return "bars"
        case .breakfast:
            return "breakfast"
        case .cafe:
            return "coffee_tea"
        case .dessert:
            return "dessert"
        }
    }
}

struct FilterCategory {
    let title: String
    var accessoryType: FilterAccessoryType = .none
    var key = ""
}
