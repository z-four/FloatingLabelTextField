# FloatingLabelTextField

[![Version](https://img.shields.io/cocoapods/v/FloatingLabelTextField.svg?style=flat)](https://cocoapods.org/pods/FloatingLabelTextField)
[![License](https://img.shields.io/cocoapods/l/FloatingLabelTextField.svg?style=flat)](https://cocoapods.org/pods/FloatingLabelTextField)
[![Platform](https://img.shields.io/cocoapods/p/FloatingLabelTextField.svg?style=flat)](https://cocoapods.org/pods/FloatingLabelTextField)

<p align="center">
  <img src="/Images/login.gif" height = "325px">
  <img src="/Images/register.gif" height = "325px">
</p>

## Usage

```swift
 @IBOutlet private weak var floatingLabelTextField: FloatingLabelTextField!
    
 override func viewDidLoad() {
     super.viewDidLoad()
    
     // Add right label with color
     floatingLabelTextField.addRightText("Forgot?", color: UIColor.white)
    
     // Add right images
     floatingLabelTextField.addRightImages([UIImage(named: "image")!])
     
     // Toggle text format, whether secured or not
     floatingLabelTextField.toggleTextFormat()
     
     // Update secure line and description text 
     floatingLabelTextField.updateSecureLine(to: .max, text: "Some description", color: .red)
     
     // Check if current mode is secure
     floatingLabelTextField.isSecure
     
     // Change the keyboard type
     floatingLabelTextField.setKeyboardType(.emailAddress)
     
     // Change the autocorrection type
     floatingLabelTextField.setAutocorrectionType(.no)
     
     // Configure style programmatically
     floatingLabelTextField.separatorColor = .blue
     floatingLabelTextField.headerText = "Header"
     floatingLabelTextField.headerColor = .green
     floatingLabelTextField.placeholderText = "Placeholder"
     floatingLabelTextField.placeholderColor = .red
     floatingLabelTextField.selectionColor = .red
     floatingLabelTextField.textColor = .white
 }
 
 override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     
     // Update text once view has been loaded
     floatingLabelTextField.text = "Some text"
     
     // Get inputted text whenever you want
     floatingLabelTextField.text
 }
 
```

Also you can configure style via Interface Builder

```swift
  @IBInspectable var separatorColor: UIColor
  @IBInspectable var headerColor: UIColor
  @IBInspectable var headerText: String?
  @IBInspectable var placeholderColor: UIColor 
  @IBInspectable var placeholderText: String?
  @IBInspectable var textColor: UIColor
  @IBInspectable var selectionColor: UIColor
  @IBInspectable var isSecure: Bool
```

##### Delegate

```swift
 extension ViewController: FloatingLabelTextFieldDelegate {
    
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
```

##### Listener

```swift
  floatingLabelTextField.events.append() { event in
         switch(event) {
             case .didStartEditing( _): print("DidStartEditing")
             case .didEndEditing( _): print("DidEndEditing")
             case .didTextChanged( _): print("DidTextChanged")
             case .didExtraButtonPressed(let floatingTextField, let index, let button):
                 if index == 0 {
                     // Change current text format
                     floatingTextField.toggleTextFormat()
                    
                     // Update button if needed
                     button.setImage(UIImage(named: floatingTextField.isSecute() ? "eye_off" : "eye_on")!, for: .normal)
                 }
         }
  }
```

## Requirements

* iOS 9.0+
* CocoaPods 1.0.0+
* Swift 5

## Installation

FloatingLabelTextField is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FloatingLabelTextField'
```

## License

This project is licensed under the MIT license.

Copyright (c) 2019 Dmitriy Zhyzhko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
