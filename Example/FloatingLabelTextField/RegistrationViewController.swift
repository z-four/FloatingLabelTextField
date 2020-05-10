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
final class RegistrationViewController: UIViewController {
    
    @IBOutlet private weak var passwordFloatingTextField: FloatingLabelTextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordFloatingTextField.addRightImages([UIImage.init(named: "eye")!.withTintColor(UIColor.white),
                                                  UIImage.init(named: "copy")!])
        passwordFloatingTextField.delegate = self
        passwordFloatingTextField.events.append() { event in
            switch(event) {
            case .didStartEditing( _): print("DidStartEditing")
            case .didEndEditing( _): print("DidEndEditing")
            case .didTextChanged( _): print("DidTextChanged")
            case .didRightButtonPressed(let floatingTextField, let index, _):
                if index == 0 {
                    floatingTextField.toggleTextFormat()
                }
            }
        }
    }
}

// MARK: - FloatingTextFieldDelegate
extension RegistrationViewController: FloatingLabelTextFieldDelegate {
    
    func state(for floatingTextField: FloatingLabelTextField) -> (state: InputTextState, description: String?, color: UIColor) {
        let textLength = floatingTextField.text.count
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
