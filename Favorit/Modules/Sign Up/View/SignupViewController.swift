//
//  SignUpViewController.swift
//  Favorit
//
//  Created by ONS on 18/11/23.
//

import UIKit
import NVActivityIndicatorView

class SignUpViewController: UIViewController {
    
    @Dependency private var viewModel: SignupViewModel
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup
    private func setup() {
        self.signupButton.rounded()
        self.setupBindings()
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
    @IBAction func didTapClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.signUpUserInput = SignUpUserInput(email: emailTextField.text,
                                                    firstName: firstNameTextField.text,
                                                    lastName: lastNameTextField.text,
                                                    password: passwordTextField.text)
        viewModel.signUp { [weak self] result in
            switch result {
            case .success(_):
                self?.showMessage(title: "Success",
                                  message: "User Created  Success. Please login again!") {_ in 
                    self?.dismiss(animated: true)
                }
            case .failure(let failure):
                self?.showError(message: failure.message)
            }
        }
    }
}
