//
//  SignupViewController+Factory.swift
//  Favorit
//
//  Created by ONS on 02/12/23.
//

import UIKit

extension PlacesViewController {
    public static func createPlacesViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FavoritNavigationViewController") as? UINavigationController
    }
}
