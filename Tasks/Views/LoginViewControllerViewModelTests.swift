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
//    var subject: TasksViewControllerViewModel!

    override func setUp() {
        super.setUp()
        
        mockService = MockLoginViewControllerViewModelService()
//        subject = TasksViewControllerViewModel(service: mockService)
    }

    func testExample() throws {
        XCTAssertTrue(true)
    }

}
