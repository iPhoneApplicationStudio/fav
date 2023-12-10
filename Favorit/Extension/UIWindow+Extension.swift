//
//  UIWindow+Extension.swift
//  Favorit
//
//  Created by ONS on 06/12/23.
//

import UIKit

extension UIWindow {
    class var topWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        
        if let windowScene = scene as? UIWindowScene {
            return windowScene.keyWindow
        }
        
        return nil
    }
}
