//
//  LoginViewControllerViewModelService.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/27/25.
//

import Foundation

final class LoginViewControllerViewModelService: LoginViewControllerViewModelServiceProtocol {
    
    func retrieveAccessToken(_ username: String, _ password: String, completion: @escaping ((Result<LoginResponse, Error>)) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/djangoapp/login") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["userName": username, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized"])))
                return
            }
            if let data = data {
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    guard let status = loginResponse.status else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized"])))
                        return
                    }
                    TokenManager.shared.updateTokens(accessToken: loginResponse.userName, refreshToken: status.rawValue)
                    completion(.success((loginResponse)))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
}
