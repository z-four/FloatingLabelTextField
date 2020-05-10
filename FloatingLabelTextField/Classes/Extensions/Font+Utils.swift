//
//  Font+Utils.swift
//  FloatingTextField
//
//  Created by Dmitriy Zhyzhko on 25.11.2018.
//

import Foundation

typealias FontFamily = UIFont

protocol FontConvertible {
    func font(size: CGFloat) -> UIFont
    static func printNamesFromFamily() -> Void
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
    
    func font(size: CGFloat) -> UIFont {
        return UIFont(self, size: size)
    }
    
    static func printNamesFromFamily()  {
        let fontFamily = String(describing: self)
        UIFont.printFonts(for: fontFamily)
    }
}

extension UIFont {
    
    enum Gerbera: String, FontConvertible  {
        case black = "Gerbera-Black"
        case bold = "Gerbera-Bold"
        case medium = "Gerbera-Medium"
        case regular = "Gerbera-Regular"
        case light = "Gerbera-Light"
    }
    
    convenience init<FontType: FontConvertible> (_ font: FontType,
                                                 size: CGFloat) where FontType: RawRepresentable, FontType.RawValue == String {
        self.init(name: font.rawValue, size: size)!
    }
    
    class func printFonts(for familyName: String) {
        let fontFamilyNames = UIFont.familyNames
        guard fontFamilyNames.contains(familyName) else {
            print("familyName \"\(familyName)\" not found")
            return
        }
        let names = UIFont.fontNames(forFamilyName: familyName)
        names.forEach{ print("\t- \($0)") }
    }
    
    class func printAllFonts() {
        let fontFamilyNames = UIFont.familyNames
        fontFamilyNames.forEach{ UIFont.printFonts(for: $0) }
    }
}

extension UIFont {
    
    
    /// Loads font by name.
    /// - Parameter name: Given font name.
    static func loadFont(name: String) {
        guard
            let fontURL = fontURL(for: name),
            let data = try? Data(contentsOf: fontURL),
            let provider = CGDataProvider(data: data as CFData),
            let font = CGFont(provider)
            else { return }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            // Can produce font already added error, skip handling
        }
    }
    
    /// Returns font url by passed font name.
    /// - Parameter fontName: Font name.
    /// - Returns: Url of the font.
    static func fontURL(for fontName: String) -> URL? {
        let bundle = Bundle(for: FloatingLabelTextField.self)

        if let fontURL = bundle.url(forResource: fontName, withExtension: "otf") {
            return fontURL
        }
        
        if let fontURL = bundle.url(forResource: fontName, withExtension: "otf", subdirectory: "FloatingLabelTextField.swift.bundle") {
            return fontURL
        }
        
        return nil
    }
    
    
    /// Register all the library fonts
    static func registerLibraryFonts() {
        loadFont(name: Gerbera.black.rawValue)
        loadFont(name: Gerbera.bold.rawValue)
        loadFont(name: Gerbera.light.rawValue)
        loadFont(name: Gerbera.medium.rawValue)
        loadFont(name: Gerbera.regular.rawValue)
    }
}
