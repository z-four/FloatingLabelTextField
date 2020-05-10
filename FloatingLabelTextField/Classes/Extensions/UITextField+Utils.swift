//
//  UITextField+Utils.swift
//  FloatingLabelTextField
//
//  Created by Dmitriy Zhyzhko on 10.05.2020.
//

import Foundation

extension UITextField {
    
    func selectedTextIndexes() -> (startIndex: String.Index, endIndex: String.Index)? {
        if let range = self.selectedTextRange {
            if !range.isEmpty {
                let location = self.offset(from: self.beginningOfDocument, to: range.start)
                let length = self.offset(from: range.start, to: range.end)
                
                let startIndex = self.text!.index(self.text!.startIndex, offsetBy: location)
                let endIndex = self.text!.index(startIndex, offsetBy: length)
                
                return (startIndex, endIndex)
            }
        }
        return nil
    }
}
