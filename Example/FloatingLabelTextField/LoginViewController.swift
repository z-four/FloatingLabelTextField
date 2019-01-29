//
//  ViewController.swift
//  FloatingTextField
//
//  Created by z-four
//  Copyright (c) 2018 z-four. All rights reserved.
//

import UIKit
import FloatingLabelTextField

// MARK: - Lifecycle
final class LoginViewController: BaseViewController {

    @IBOutlet private weak var emailFloatingTextField: FloatingLabelTextField!
    @IBOutlet private weak var passwordFloatingTextField: FloatingLabelTextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        emailFloatingTextField.textField?.keyboardType = .emailAddress
        passwordFloatingTextField.addRightExtraView(text: "Forgot?", color: UIColor(hex: "00ab80"))
    }
}
