//
//  FloatingAddButton.swift
//  Favorit
//
//  Created by ONS on 10/17/19.
//  Copyright © 2019 Bushman Studio. All rights reserved.
//

import UIKit

class FloatingAddButton: UIButton {    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
    }
}
