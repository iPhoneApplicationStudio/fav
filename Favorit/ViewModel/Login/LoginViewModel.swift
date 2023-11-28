//
//  LoginViewModel.swift
//  Favorit
//
//  Created by ONS on 25/11/23.
//

import Foundation
import Alamofire

protocol LoginProtocol: AnyObject {
    func isValidEmail(_ mail: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    
    func loginRequest(email: String?,
                      password: String?,
                      handler: @escaping LoginHandler)
}

class LoginViewModel: LoginProtocol {
    func isValidEmail(_ mail: String) -> Bool {
        return mail.isValidMailID
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.isValidPassword
    }
    
    func loginRequest(email: String?,
                      password: String?,
                      handler: @escaping LoginHandler) {
        guard let email = email, let password = password else {
            handler(nil)
            return
        }
        
        let url = FavoritApi.login.value
        let parameters = ["email": email, "password": password]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters).response { response in
            debugPrint(response)
        }
        
        //this is equi
    }
}
