//
//  FollowingViewController+Factory.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

extension FollowingViewController {
    
    public static func createFollowingViewController() -> FollowingViewController {
        let storyboard = UIStoryboard(name: "FollowingViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! FollowingViewController
    }
}
