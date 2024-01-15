//
//  RadiusViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 02/01/24.
//

import Foundation


protocol FilterPlacesProtocol: AnyObject {
    var totalSection: Int { get }
    var bindViewModelToController : ((_ frequency: RadiusFrequency,
                                      _ categories: [String]) -> ())? { get set }
    
    func numberOfItemsFor(section: Int) -> Int
    func titleFor(section: Int) -> String
    func getItemFor(index: Int, section: Int) -> String
    func getAccessoryTypeFor(index: Int, section: Int) -> FilterAccessoryType
    func setAccessoryTypeFor(index: Int, section: Int)
}

class FilterPlacesViewModel: FilterPlacesProtocol {
    enum FilterSection: Int, CaseIterable {
        case radius
        case category
        
        var title: String {
            switch self {
            case .radius:
                return "Distance"
            case .category:
                return "Categories"
            }
        }
    }
    
    var bindViewModelToController: ((RadiusFrequency, [String]) -> ())?
    
    private var lastSelectedRadiusFrequencyIndex = 0
    private var allSelectedCategoriesIndexCount = 1
    
    private lazy var allRadiusFrequency = {
        let allFrequencies = RadiusFrequency.allCases
        var frequencies = allFrequencies.map { frequency in
            FilterCategory(title: frequency.title,
                           accessoryType: frequency == FavoritConstant.defaultFrequency ? .checkmark : .none)
        }
        
        return frequencies
    }()
    
    private var allCategories = [FilterCategory(title: "Restaurants",
                                                accessoryType: .checkmark,
                                                key: "restaurant"),
                                 FilterCategory(title: "Bars",
                                                key: "bars"),
                                 FilterCategory(title: "Breakfast",
                                                key: "breakfast"),
                                 FilterCategory(title: "Coffee/Tea",
                                                key: "coffee_tea"),
                                 FilterCategory(title: "Dessert",
                                                key: "dessert")]
    
    var totalSection: Int {
        return FilterSection.allCases.count
    }
    
    func numberOfItemsFor(section: Int) -> Int {
        guard let filterSection = FilterSection(rawValue: section) else {
            return 0
        }
        
        switch filterSection {
        case .radius:
            return allRadiusFrequency.count
        case .category:
            return allCategories.count
        }
    }
    
    func titleFor(section: Int) -> String {
        guard let filterSection = FilterSection(rawValue: section) else {
            return ""
        }
        
        return filterSection.title
    }
    
    func getItemFor(index: Int, section: Int) -> String {
        guard index >= 0,
              let filterSection = FilterSection(rawValue: section) else {
            return ""
        }
        
        switch filterSection {
        case .radius:
            return allRadiusFrequency[index].title
        case .category:
            return allCategories[index].title
        }
    }
    
    func getAccessoryTypeFor(index: Int, section: Int) -> FilterAccessoryType {
        guard index >= 0,
              let filterSection = FilterSection(rawValue: section) else {
            return .none
        }
        
        switch filterSection {
        case .radius:
            return allRadiusFrequency[index].accessoryType
        case .category:
            return allCategories[index].accessoryType
        }
    }
    
    func setAccessoryTypeFor(index: Int, section: Int) {
        guard index >= 0,
              let filterSection = FilterSection(rawValue: section) else {
            return
        }
        
        switch filterSection {
        case .radius:
            guard index != lastSelectedRadiusFrequencyIndex else {
                return
            }
            
            allRadiusFrequency[index].accessoryType = .checkmark
            allRadiusFrequency[lastSelectedRadiusFrequencyIndex].accessoryType = .none
            lastSelectedRadiusFrequencyIndex = index
        case .category:
            allCategories[index].accessoryType = allCategories[index].accessoryType == .none ? .checkmark : .none
            let isSelected = allCategories[index].accessoryType == .checkmark
            allSelectedCategoriesIndexCount += isSelected ? 1 : -1
            if allSelectedCategoriesIndexCount == 0 {
                allCategories[0].accessoryType = .checkmark
                allSelectedCategoriesIndexCount = 1
            }
        }
        
        self.getSelectedFrequencyAndCategories()
    }
    
    private func getSelectedFrequencyAndCategories() {
        let selectedCategories = allCategories.compactMap { category in
            if category.accessoryType == .checkmark {
                return category.key
            } else {
                return nil
            }
        }
        
        let selectedFrequencyTitle = allRadiusFrequency[lastSelectedRadiusFrequencyIndex].title
        let selectedFrequency = RadiusFrequency(rawValue: selectedFrequencyTitle) ?? FavoritConstant.defaultFrequency
        bindViewModelToController?(selectedFrequency, selectedCategories)
    }
}
