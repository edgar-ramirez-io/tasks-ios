//
//  LoginViewModel.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/27/25.
//

import Foundation
import UIKit

class LoginViewModel {    
    var userName: String?
    var statusEnum: LoginUserStatus?
    
    private let service: LoginViewControllerViewModelServiceProtocol
    
    init(service: LoginViewControllerViewModelServiceProtocol = LoginViewControllerViewModelService()) {
        self.service = service
    }
}

extension LoginViewModel {
    var status: String? {
        return self.statusEnum?.rawValue
    }
    
    func login(_ username: String, _ password: String, completion: @escaping(Result<Void, Error>) -> Void) {
        service.retrieveAccessToken(username, password) { result in
            switch result {
            case .success(let data):
                self.userName = data.userName
                self.statusEnum = data.status
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
