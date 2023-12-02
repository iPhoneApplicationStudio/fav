//
//  AppCoordinator.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation
import UIKit

final class AppCoordinator {
    
    @Dependency private(set) var userSessionService: UserSessionService
    
    let window: UIWindow
    
    init(with window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
    }
    
    func start() {
        if userSessionService.isLoggedIn {
            showHome()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let storyBoard = UIStoryboard(name: StoryboardName.login.value,
                                      bundle: nil)
        guard let loginVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.login.value) as? LoginViewController else {
            return
        }
        loginVC.loginCompletion = showHome
        setup(root: loginVC)
    }
    
    func showHome() {
        setup(root: HomeTabBarViewController())
    }
    
    private func setup(root: UIViewController, animated: Bool = true) {
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
}
