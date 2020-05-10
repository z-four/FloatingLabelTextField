//
//  AttributedLabel.swift
//  FloatingTextFiled
//
//  Created by z4
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation
import UIKit.UILabel

// MARK: - Lifecycle
public final class AttributedLabel: UILabel {
    
    public var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern,
                                                                  at: 0,
                                                                  effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else { return 0 }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}

// MARK: - Configure
extension AttributedLabel {
    
    
    /// Configure attributed string with default params
    private func configure() {
        let attrString = NSMutableAttributedString(string: "")
        attrString.addAttribute(NSAttributedString.Key.font,
                                value: self.font ?? FontFamily.Gerbera.light,
                                range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}


// MARK: - Getters & setters
extension AttributedLabel {
      
    func setText(text: String?, color: UIColor = .white) {
        guard let text = text else { return }
        self.text = text
          
        let attributes = self.attributedText?.attributes(at: 0, effectiveRange: nil)
        let attr = NSMutableAttributedString.init(string: text, attributes: attributes)
        attr.addAttributes([.foregroundColor : color], range: NSRange(text.range(of: text)!, in: text))
        self.attributedText = attr
    }
    
    func getText() -> String? {
        return self.attributedText?.string
    }
}
