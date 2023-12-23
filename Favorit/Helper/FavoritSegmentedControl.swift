//
//  FavoritSegmentedControl.swift
//  Favorit
//
//  Created by Chris Piazza on 10/21/19.
//  Copyright © 2019 Bushman Studio. All rights reserved.
//

import UIKit

class FavoritSegmentedControl: UISegmentedControl {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = .primaryColor
            tintColor = .accentColor

        } else {
            tintColor = .primaryColor
        }
                
        setTitleTextAttributes([.foregroundColor: tintColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .light)], for: .normal)
        
        
        setTitleTextAttributes([.foregroundColor: setTextColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .light)], for: .selected)

    }
    
    
    private func setTextColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
