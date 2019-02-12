//
//  RegistrationViewController.swift
//  FloatingTextField_Example
//
//  Created by Dmitriy Zhyzhko
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FloatingLabelTextField

// MARK: - Lifecycle
final class RegistrationViewController: BaseViewController {
    
    @IBOutlet private weak var passwordFloatingTextField: FloatingLabelTextField!
    
    private var isPasswordShown = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordFloatingTextField.delegate = self
        passwordFloatingTextField.events.append() { event in
            switch(event) {
                case .didStartEditing( _): print("didStartEditing")
                case .didEndEditing( _): print("didEndEditing")
                case .didTextChanged( _): print("didTextChanged")
                case .didExtraButtonPressed(let floatingTextField, let index, let button):
                    if index == 0 {
                        floatingTextField.switchTextFormat(secure: self.isPasswordShown)
                        button.setImage(UIImage(named: self.isPasswordShown ? "eye_off" : "eye_on")!, for: .normal)
                    
                        self.isPasswordShown = !self.isPasswordShown
                    }
            }
        }
    }
}

// MARK: - FloatingTextFieldDelegate
extension RegistrationViewController: FloatingLabelTextFieldDelegate {
    
    func state(for floatingTextField: FloatingLabelTextField) -> (state: InputTextState, description: String?, color: UIColor) {
        let textLength = floatingTextField.getText().count
        switch textLength {
            case 1...2: return (.invalid, "Invalid", UIColor(hex: "ff3f4c"))
            case 3...5: return (.unreliable, "Unreliable", UIColor(hex: "ff793f"))
            case 6...8: return (.medium, "Medium", UIColor(hex: "f5a623"))
            case 9...11: return (.reliable, "Reliable", UIColor(hex: "00ab80"))
            case let number where number >= 12: return (.max, "Max", UIColor(hex: "00c99c"))
            default: return (.idle, nil, .clear)
        }
    }
}
