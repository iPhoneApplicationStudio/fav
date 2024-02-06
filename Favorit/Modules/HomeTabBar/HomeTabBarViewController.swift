//
//  HomeTabBarViewController.swift
//  Favorit
//
//  Created by Amber Katyal on 01/12/23.
//

import UIKit

final class HomeTabBarViewController: UITabBarController {
    @Dependency private(set) var userSessionService: UserSessionService
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        LocationService.shared.locationServicesCheck { flag, _ in
            if flag == nil {
                LocationService.shared.requestAuthorization()
            } else if flag == true {
                LocationService.shared.startUpdatingLocation()
            } else if flag == false {
                self.openSettingApplication()
            }
        }
        
        self.viewControllers = createItemControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createItemControllers() -> [UIViewController] {
        HomeTabBarItem.allCases.map { tabItem in
            switch tabItem {
            case .places:
                guard let navVC = PlacesViewController.createNavPlacesViewController() else {
                    return UIViewController()
                }
                
                if let vc = navVC.topViewController as? PlacesViewController {
                    vc.viewModel = PlaceListViewModel(userID: UserDefaults.loggedInUserID ?? "")
                }
                
                navVC.tabBarItem = tabItem.tabBarItem
                return navVC
                
            case .following:
                guard let userID = userSessionService.loggedInUserID,
                      let vc = FollowViewController.createFollowViewController() else {
                    return UIViewController()
                }
                
                vc.viewModel = FollowViewModel(userID: userID,
                                               filterMode: .following)
                let nc = UINavigationController(rootViewController: vc)
                nc.tabBarItem = tabItem.tabBarItem
                return nc
                
            case .feed:
                guard let userID = userSessionService.loggedInUserID,
                      let vc = FeedViewController.createViewController(viewModel: FeedActivityViewModel(userID: userID)) else {
                    return UIViewController()
                }
                
//                vc.viewModel = FollowViewModel()
                let nc = UINavigationController(rootViewController: vc)
                nc.tabBarItem = tabItem.tabBarItem
                return nc
            }
        }
    }
    
}
