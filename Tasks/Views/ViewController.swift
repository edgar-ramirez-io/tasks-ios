//
//  ViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 3/17/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login to Tasks"
        view.backgroundColor = .systemBackground
        
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 8
        configuration.baseForegroundColor = UIColor.black
        configuration.title = "Login"
        
        let button = UIButton(
            configuration: configuration,
            primaryAction: UIAction { _ in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as? UIViewController else { fatalError("LoginViewControllerIdentifier does not exist.") }
                    if let currentVC = UIApplication.shared.keyWindow?.rootViewController {
                        currentVC.present(loginVC, animated: true)
                    }
                }
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            button.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // TODO: Use it with Delegate protocol
    private func navigateAuthenticatedUsersToMain() {
        if let accessToken = TokenManager.shared.accessToken,
           !accessToken.isEmpty {
            self.navigationController?.pushViewController(TasksViewController(), animated: true)
        }
    }
}
