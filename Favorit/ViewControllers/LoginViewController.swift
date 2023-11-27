//
//  LoginViewController.swift
//  Favorit
//
//  Created by ONS on 18/11/23.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Private proerties
    private var viewModel: LoginProtocol?
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    //MARK: Private methods
    private func initialSetting() {
        viewModel = LoginViewModel()
        self.loginButton.layer.cornerRadius = loginButton.frame.height / 2
        self.loginButton.clipsToBounds = true
        self.emailTextField.delegate =  self
        self.passwordTextField.delegate = self
    }
    
    private func isValidTexts() -> Bool {
        guard let viewModel = self.viewModel else {
            return false
        }
        
        if !viewModel.isValidEmail(emailTextField.text ?? "") {
            showError(message: "Please enter valid Email")
            return false
        }
        
        if !viewModel.isValidPassword(passwordTextField.text ?? "") {
            showError(message: "Please enter your password (min 8 chars)")
            return false
        }
        
        return true
    }
    
    @IBAction func loginButtonPressed() {
        guard self.isValidTexts() else {
            return
        }
        
        self.view.endEditing(true)
        self.activityIndicatorView.startAnimating()
        //Api call
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
