//
//  FollowingViewController+Factory.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

extension FollowViewController {
    public static func createFollowViewController() -> FollowViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerName.followVC.value) as? FollowViewController
    }
}
