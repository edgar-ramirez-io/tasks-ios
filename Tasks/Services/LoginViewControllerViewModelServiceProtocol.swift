//
//  LoginViewControllerViewModelServiceProtocol.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/3/25.
//

import Foundation
import Combine

protocol LoginViewControllerViewModelServiceProtocol {
    func getUser<T: Codable>(completion: @escaping(Result<T, Error>) -> Void)
}

final class MockLoginViewControllerViewModelService: LoginViewControllerViewModelServiceProtocol {
    func getUser<T>(completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        let pathString = Bundle(for: type(of: self)).path(forResource: "users", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let users = try! JSONDecoder().decode(T.self, from: jsonData)
        completion(.success(users))
    }
    
    
}
