//
//  Double+Extension.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
