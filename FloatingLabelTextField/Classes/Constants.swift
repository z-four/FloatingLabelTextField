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
        static let height: CGFloat = 32
        static let topSpacing: CGFloat = 2
    }
    
    struct Separator {
        static let topSpacing: CGFloat = 2
    }
    
    struct StateView {
        static let topSpacing: CGFloat = 2
    }
    
    struct Description {
        static let fontSize: CGFloat = 10
        static let topSpacing: CGFloat = 6
    }
    
    struct RightLabel {
        static let fontSize: CGFloat = 15
    }
    
    struct RightImage {
        static let spacing: CGFloat = 8
    }
}
