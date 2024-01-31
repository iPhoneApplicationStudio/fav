//
//  UIViewController+Extension.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   handler: ((Bool) -> Void)?) {
        DispatchQueue.main.async {[weak self] in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok",
                                                    style: .default) { alertAction in
                handler?(true)
            })
            
            self?.present(alertController,
                          animated: true,
                          completion: nil)
        }
    }
    
    func showAlertWithYesAndNo(title: String = "",
                               message: String = "",
                               ok: String = "OK",
                               cancel: String = "Cancel",
                               handler: ((Bool) -> Void)?) {
        DispatchQueue.main.async {[weak self] in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: ok,
                                                    style: .default) { alertAction in
                handler?(true)
            })
            
            alertController.addAction(UIAlertAction(title: cancel,
                                                    style: .cancel) { alertAction in
                handler?(false)
            })
            
            self?.present(alertController,
                          animated: true,
                          completion: nil)
        }
    }
    
    func showError(message: String) {
        self.showAlert(title: "Error",
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
    
    func openSettingApplication() {
        showAlertWithYesAndNo(title: "Open Settings",
                              message: "Please allow the location persmission!!",
                              ok: "Settings") { flag in
            if flag {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
        }
    }
}
