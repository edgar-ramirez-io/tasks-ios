//
//  LoginViewControllerDismissDelegate.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/28/25.
//

import Foundation

@objc protocol LoginViewControllerDismissDelegate: AnyObject {
    @objc optional func dismissLoginViewController()
    @objc optional func dismissOtherViewControllerAndLogout()
}
