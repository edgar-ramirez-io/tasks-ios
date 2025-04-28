//
//  LoginViewControllerViewModelTests.swift
//  TasksTests
//
//  Created by Edgar Ramirez on 4/3/25.
//

import XCTest

@testable import Tasks

final class LoginViewControllerViewModelTests: XCTestCase {
    
    var mockService: LoginViewControllerViewModelServiceProtocol!
    var subject: LoginViewModel!

    override func setUp() {
        super.setUp()
        
        mockService = MockLoginViewControllerViewModelService()
        subject = LoginViewModel()
    }

    func testExample() throws {
        XCTAssertTrue(true)
    }

}
