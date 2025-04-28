//
//  LoginViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/27/25.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submit() {
        guard let usernameText = self.usernameTextField.text, 
                usernameText.count > 0,
                let passwordText = self.passwordTextField.text,
                passwordText.count > 0 else {
            
            let alert = UIAlertController(title: "Error", message: "Please enter required information.", preferredStyle: .alert)
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(cancelAlert)
            self.present(alert, animated: true)
            
            return
        }
        
        self.loginViewModel.login(usernameText, passwordText) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success():
                    let alert = UIAlertController(title: "Welcome", message: "Welcome back \(self?.loginViewModel.userName ?? "N/A") status: \(self?.loginViewModel.status ?? "N/A")", preferredStyle: .alert)
                    let okAlert = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                        self?.dismiss(animated: true)
                    }
                    
                    alert.addAction(okAlert)
                    self?.present(alert, animated: true)
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    let cancelAlert = UIAlertAction(title: "OK", style: .cancel)
                    
                    alert.addAction(cancelAlert)
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
