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
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Logging in..."
        label.textAlignment = .center
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            label.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
        
        self.navigateAuthenticatedUsersToMainOrLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func navigateAuthenticatedUsersToMainOrLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let accessToken = TokenManager.shared.accessToken,
           !accessToken.isEmpty {
            guard let mainVC = storyboard.instantiateViewController(withIdentifier: "DealersTableViewControllerIdentifier") as? DealersTableViewController else {
                fatalError("DealersTableViewController cannot be instantiated from Main.storyboard")
            }
            mainVC.dismissDelegate = self
            self.navigationController?.pushViewController(mainVC, animated: true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as? LoginViewController else { fatalError("LoginViewControllerIdentifier cannot be instantiated from Main.storyboard") }
                loginVC.dismissDelegate = self
                loginVC.modalPresentationStyle = .fullScreen
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
                   let currentVC = keyWindow.rootViewController {
                    currentVC.present(loginVC, animated: true)
                }
            }
        }
    }
}

extension ViewController: LoginViewControllerDismissDelegate {
    func dismissLoginViewController() {
        self.navigateAuthenticatedUsersToMainOrLogin()
    }
    
    func dismissOtherViewControllerAndLogout() {
        // TODO: GET http://127.0.0.1:8000/djangoapp/logout
        TokenManager.shared.clearTokens()
        self.navigateAuthenticatedUsersToMainOrLogin()
    }
}
