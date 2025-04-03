//
//  APIManager.swift
//  Tasks
//
//  Created by Edgar Ramirez on 3/17/25.
//

import Combine
import Foundation

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    // FIXME: Make it a mock service
    // https://livefront.com/writing/creating-a-service-layer-in-swift/
    
    func request<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?, completion: @escaping(Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        guard let accessToken = TokenManager.shared.accessToken else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No accessToken available"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                refreshToken { result in
                    switch result {
                    case .success(let newToken):
                        self.retryRequest(endpoint: endpoint, method: method, parameters: parameters, token: newToken, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func request<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                .eraseToAnyPublisher()
        }
        guard let accessToken = TokenManager.shared.accessToken else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No accessToken available"]))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {    // FIXME: Support retryRequest when 401
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authorizatied Access"])
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func retryRequest<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?, token: String, completion: @escaping(Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: endpoint)!) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func refreshToken(completion: @escaping(Result<String, Error>) -> Void) {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No refresh token available"])))
            return
        }

        request(endpoint: "http://localhost:3000/auth/refreshToken", method: "POST", parameters: ["refreshToken": refreshToken]) { (result: Result<TokenResponse, Error>) in
            switch result {
            case .success(let tokenResponse):
                TokenManager.shared.updateTokens(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                completion(.success(tokenResponse.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
