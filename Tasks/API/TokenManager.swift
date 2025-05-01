//
//  TokenManager.swift
//  Tasks
//
//  Created by Edgar Ramirez on 3/17/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    var refreshToken: String?
    var accessToken: String? { // TODO: Store real accessToken
        get {
            return UserDefaults.standard.value(forKey: "userName") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userName")
        }
    }
    
    private init() {}
    
    func updateTokens(accessToken: String, refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
}

/*
 POST http://localhost:3000/auth/signin
 
 {
     "accessToken": "<accessToken>"
 }
 */
struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
}
