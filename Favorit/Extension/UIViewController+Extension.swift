//
//  UIViewController+Extension.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import UIKit

extension UIViewController {
    func showError(title: String = "Error",
                   message: String) {
        let alertController = UIAlertController(title: title, 
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", 
                                                style: .default) { alertAction in
        })
        
        self.present(alertController, 
                     animated: true,
                     completion: nil)
    }
}
