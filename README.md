# FloatingLabelTextField

[![Version](https://img.shields.io/cocoapods/v/FloatingLabelTextField.svg?style=flat)](https://cocoapods.org/pods/FloatingLabelTextField)
[![License](https://img.shields.io/cocoapods/l/FloatingLabelTextField.svg?style=flat)](https://cocoapods.org/pods/FloatingLabelTextField)
[![Platform](https://img.shields.io/cocoapods/p/FloatingLabelTextField.svg?style=flat)](https://cocoapods.org/pods/FloatingLabelTextField)

## Example

<p align="center">
  <img src="/Images/login.gif" height = "325px">
  <img src="/Images/register.gif" height = "325px">
</p>

## Usage

##### Code:

```swift
 @IBOutlet private weak var floatingLabelTextField: FloatingLabelTextField!
    
 override func viewDidLoad() {
     super.viewDidLoad()
    
     floatingLabelTextField.addRightExtraView(text: "Forgot?", color: UIColor(hex: "00ab80"))
    
     //add images as right view
     floatingLabelTextField.addRightExtraViews(images: [UIImage(named: "image")!])
     
     //disable/enable secure mode
     floatingLabelTextField.switchTextFormat(secure: false)
     
     //update bottom line state
     floatingLabelTextField.updateSecureLine(to: .max, text: "Some description", color: .red)
 }
 
```
##### Interface builder:
```swift
  @IBInspectable var separatorColor: UIColor?
  @IBInspectable var headerColor: UIColor
  @IBInspectable var headerText: String?
  @IBInspectable var placeholderColor: UIColor 
  @IBInspectable var placeholderText: String?
  @IBInspectable var isSecure: Bool = true
```
## Requirements

- CocoaPods 1.0.0+

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
