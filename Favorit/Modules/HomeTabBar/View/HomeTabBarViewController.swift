//
//  HomeTabBarViewController.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

final class HomeTabBarViewController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = createItemControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createItemControllers() -> [UIViewController] {
        
        HomeTabBarItem.allCases.map { tabItem in
            switch tabItem {
            case .following:
                let vc = FollowingViewController.createFollowingViewController()
                let nc = UINavigationController(rootViewController: vc)
                nc.tabBarItem = tabItem.tabBarItem
                return nc
            case .places:
                let vc = UIViewController()
                vc.tabBarItem = tabItem.tabBarItem
                return vc
            }
        }
    }
    
}
