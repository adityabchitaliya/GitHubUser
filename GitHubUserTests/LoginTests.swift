//
//  LoginTests.swift
//  GitHubUserTests
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import XCTest
@testable import GitHubUser
class LoginTests: XCTestCase {
    func testValidEmailAddress(){
        let loginView = LoginViewController()
        XCTAssertFalse(loginView.isEmailAddressValid("demo"))
        XCTAssertTrue(loginView.isEmailAddressValid("demo@demo.com"))
        XCTAssertTrue(loginView.isEmailAddressValid("1@1.com"))
    }
    func testValidPassword() {
        let loginView = LoginViewController()
        XCTAssertFalse(loginView.isPasswordValid("ps"))
        XCTAssertTrue(loginView.isPasswordValid("password"))
        XCTAssertTrue(loginView.isPasswordValid(" pass "))
    }
}

