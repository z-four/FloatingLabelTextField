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
final class LoginViewController: UIViewController {

    @IBOutlet private weak var emailFloatingTextField: FloatingLabelTextField!
    @IBOutlet private weak var passwordFloatingTextField: FloatingLabelTextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordFloatingTextField.addRightText("Forgot?", color: UIColor.white)
    }
}
