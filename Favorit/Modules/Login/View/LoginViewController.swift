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
    
    //MARK: Proerties
    @Dependency private var viewModel: LoginViewModel
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Private methods
    private func setup() {
        self.loginButton.rounded()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.handleLoadingState = { [weak self] state in
            DispatchQueue.main.async {
                if state {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func loginButtonPressed() {
        self.view.endEditing(true)
        viewModel.loginRequest(
            email: emailTextField.text,
            password: passwordTextField.text)
        { [weak self] result in
            switch result {
            case .success:
                // go to home
                break
            case .failure(let error):
                self?.showError(message: error.message)
            }
        }
    }
}
