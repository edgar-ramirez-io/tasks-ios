//
//  LoginViewControllerViewModelServiceProtocol.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/3/25.
//

import Foundation
import Combine

protocol LoginViewControllerViewModelServiceProtocol {
    func retrieveAccessToken(_ username: String, _ password: String, completion: @escaping((Result<LoginResponse, Error>)) -> Void)
}

final class MockLoginViewControllerViewModelService: LoginViewControllerViewModelServiceProtocol {
    func retrieveAccessToken(_ username: String, _ password: String, completion: @escaping ((Result<LoginResponse, Error>)) -> Void) {
        let pathString = Bundle(for: type(of: self)).path(forResource: "users", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let users = try! JSONDecoder().decode(LoginResponse.self, from: jsonData)
        completion(.success(users))
    }
}
