//
//  UIViewController+Extension.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import UIKit

extension UIViewController {
    private func showAlert(title: String,
                           message: String,
                           handler: ((Bool) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: .default) { alertAction in
            handler?(true)
        })
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    func showError(message: String) {
        showAlert(title: "Error",
                  message: message,
                  handler: nil)
    }
    
    func showMessage(title: String,
                     message: String,
                     handler: @escaping (Bool) -> Void) {
        showAlert(title: title,
                  message: message,
                  handler: handler)
    }
}
