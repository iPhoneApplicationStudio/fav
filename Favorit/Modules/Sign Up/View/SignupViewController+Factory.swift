//
//  SignupVC.swift
//  Favorit
//
//  Created by ONS on 02/12/23.
//

import UIKit

extension SignUpViewController {
    public static func createSignupViewController() -> SignUpViewController? {
        let storyboard = UIStoryboard(name: "SignUpViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? SignUpViewController
    }
}
