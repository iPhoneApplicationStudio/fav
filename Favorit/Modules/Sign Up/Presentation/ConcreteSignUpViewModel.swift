//
//  ConcreteSignUpViewModel.swift
//  Favorit
//
//  Created by Amber Katyal on 29/11/23.
//

import Foundation

final class ConcreteSignUpViewModel: SignupViewModel {
    
    var signUpUserInput: SignUpUserInput = SignUpUserInput()
    
    var handleLoadingState: ((Bool) -> Void)?
    
    func signUp(completion: @escaping (Result<SignUpResponse, SignupError>) -> Void) {
        <#code#>
    }
    
    
}
