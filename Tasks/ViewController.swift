//
//  ViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 3/17/25.
//

import UIKit

class ViewController: UIViewController {
    private let tasksViewModel = TasksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove me
        let label = UILabel()
        label.text = "Hello, UIKit!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            label.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
        
        // FIXME: Remove it and implement Login
        retrieveAccessToken { [weak self] result in
            switch result {
            case .success(_):
                print("authenticated")
                self?.setupTasksList()
            case .failure(_):
                print("Not authenticated")
            }
        }
    }
    
    private func setupTasksList() {
        tasksViewModel.getTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.updateTasksListUI(with: tasks)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func updateTasksListUI(with tasks: [Task]) {
        print(tasks)
    }

}

class TasksViewModel {
    var tasks: [Task]?
    
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        let endpoint = "http://localhost:3000/tasks/"
        
        APIManager.shared.request(endpoint: endpoint, method: "GET", parameters: nil) { [weak self] (result: Result<[Task], Error>) in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ViewController {
    private func retrieveAccessToken(completion: @escaping((Result<Void  , Error>)) -> Void) {
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
