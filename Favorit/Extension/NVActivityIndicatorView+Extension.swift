//
//  NVActivityIndicatorView+Extension.swift
//  Favorit
//
//  Created by Abhinay Maurya on 31/01/24.
//

import Foundation
import NVActivityIndicatorView

extension NVActivityIndicatorView {
    func start() {
        DispatchQueue.main.async {[weak self] in
            self?.isHidden = false
            self?.startAnimating()
        }
    }
    
    func stop() {
        DispatchQueue.main.async {[weak self] in
            self?.isHidden = true
            self?.stopAnimating()
        }
    }
}
