//
//  ApplicationAppearance.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import UIKit

final class ApplicationAppearance {
    static func initialAppearance() {
        guard let primaryColor = UIColor.primaryColor,
              let accentColor = UIColor.accentColor 
        else {
            return
        }
        
        let font = UIFont.systemFont(ofSize: 18,
                                     weight: UIFont.Weight.thin)
        
        //UIBarButtonItem
        if let navigationBarType = UINavigationBar.classForCoder() as? UIAppearanceContainer.Type {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [navigationBarType]).setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: primaryColor], for: .normal)
        }
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: accentColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, 
                                                            for: .normal)
        //UITabBarItem
        let tabBarFont = UIFont.systemFont(ofSize: 15,
                                           weight: UIFont.Weight.thin)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: tabBarFont, 
                                                          NSAttributedString.Key.foregroundColor: accentColor], for: .selected)
        UITabBar.appearance().tintColor = primaryColor
        
        //UINavigationBar
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font,
                                                            NSAttributedString.Key.foregroundColor: primaryColor]
        UINavigationBar.appearance().tintColor = primaryColor
    }
}
