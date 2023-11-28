//
//  SignupViewController.swift
//  Favorit
//
//  Created by ONS on 18/11/23.
//

import UIKit

class SignupViewController: UIViewController {
    
    @Dependency private var viewModel: SignupViewModel
    
    // MARK: - IBOutlets
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setup() {
        
    }
    
    // MARK: - Actions
    @IBAction func didTapSignUp(_ sender: UIButton) {
        viewModel.signUp { [weak self] result in
            switch result {
            case .success(let success):
                <#code#>
            case .failure(let failure):
                self?.showError(message: failure.message)
            }
        }
    }
}
