//
//  FavoritNavigationViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 10/2/18.
//  Copyright © 2018 Bushman Studio. All rights reserved.
//

import UIKit

class FavoritNavigationViewController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, 
                              willShow viewController: UIViewController, animated
                              nimated: Bool) {
        let item = UIBarButtonItem(title: " ",
                                   style: .plain,
                                   target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
