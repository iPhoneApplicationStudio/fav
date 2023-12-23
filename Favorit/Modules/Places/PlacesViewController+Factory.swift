//
//  SignupViewController+Factory.swift
//  Favorit
//
//  Created by ONS on 02/12/23.
//

import UIKit

extension PlacesViewController {
    public static func createNavPlacesViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerName.favoritNavVC.value) as? UINavigationController
    }
}
