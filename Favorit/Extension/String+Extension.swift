//
//  String+Extension.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation

extension String {
    var isValidMailID: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let password = self.trimmingCharacters(in: .whitespaces)
        return password.count > 7
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
