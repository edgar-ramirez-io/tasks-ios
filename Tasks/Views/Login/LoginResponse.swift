//
//  LoginUser.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/27/25.
//

import Foundation

/*
 {
     "userName": "username",
     "status": "Authenticated"
 }
 */

enum LoginUserStatus: String, Codable {
    case Authenticated
    case loggedOut
}

struct LoginResponse: Codable {
    let userName: String
    let status: LoginUserStatus?
}
