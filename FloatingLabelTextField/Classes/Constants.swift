//
//  Constants.swift
//  FloatingLabelTextField
//
//  Created by Dmitriy Zhyzhko on 10.05.2020.
//

import Foundation

struct Constants {
    
    static let secureChar = "●"
    
    struct Header {
        static let fontSize: CGFloat = 12
        static let letterSpacing: CGFloat = -0.2
        static let animDuration: TimeInterval = 0.3
    }
    
    struct TextField {
        static let secureLetterSpacing: CGFloat = 5
        static let unsecureLetterSpacing: CGFloat = -0.6
        static let fontSize: CGFloat = 18
    }
    
    struct Description {
        static let fontSize: CGFloat = 10
    }
    
    struct RightLabel {
        static let fontSize: CGFloat = 15
    }
    
    struct RightImage {
        static let spacing: CGFloat = 8
    }
}
