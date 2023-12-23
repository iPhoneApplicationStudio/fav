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
            case .tracking:
                guard let vc = FollowViewController.createFollowViewController() else {
                    return UIViewController()
                }
                
                vc.viewModel = FollowViewModel()
                let nc = UINavigationController(rootViewController: vc)
                nc.tabBarItem = tabItem.tabBarItem
                return nc
            case .places:
                guard let navVC = PlacesViewController.createNavPlacesViewController() else {
                    return UIViewController()
                }
                
                if let vc = navVC.topViewController as? PlacesViewController {
                    vc.viewModel = PlaceListViewModel(userID: UserDefaults.loggedInUserID ?? "")
                }
                
                navVC.tabBarItem = tabItem.tabBarItem
                return navVC
            }
        }
    }
    
}
