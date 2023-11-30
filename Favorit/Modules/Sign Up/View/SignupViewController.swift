//
//  SignUpViewController.swift
//  Favorit
//
//  Created by ONS on 18/11/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @Dependency private var viewModel: SignupViewModel
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        
    }
    
    // MARK: - Actions
    @IBAction func didTapClose(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        viewModel.signUp { [weak self] result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                self?.showError(message: failure.message)
            }
        }
    }
}
