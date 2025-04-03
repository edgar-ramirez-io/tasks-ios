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
            primaryAction: UIAction { [weak self] _ in
                print("authenticating....")
                guard let weakSelf = self else { return }
                // FIXME: Remove it and implement Login
                weakSelf.retrieveAccessToken("", "") { result in
                    switch result {
                    case .success(_):
                        print("authenticated")
                        DispatchQueue.main.async { [weak self] in
                            guard let weakSelf = self else { return }
                            weakSelf.navigationController?.pushViewController(TasksViewController(), animated: true)
                        }
                    case .failure(_):
                        print("Not authenticated")
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
}

extension ViewController {
    private func retrieveAccessToken(_ username: String, _ password: String, completion: @escaping((Result<Void  , Error>)) -> Void) {
        guard let url = URL(string: "http://localhost:3000/auth/signin") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
               
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username": "", "password": ""]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    TokenManager.shared.updateTokens(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
