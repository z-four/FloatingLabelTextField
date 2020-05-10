//
//  FloatingLabelTextField
//  Pods
//
//  Created by z4
//

import Foundation
import UIKit.UITextField

// MARK: - Lifecycle
@IBDesignable public class FloatingLabelTextField: UIView {
    
    @IBInspectable public var separatorColor: UIColor? {
        set { separatorView?.backgroundColor = newValue }
        get { return UIColor.dividerColor }
    }
    
    @IBInspectable public var headerColor: UIColor {
        set { headerLabel?.textColor = newValue }
        get { return UIColor.floatingLabelColor  }
    }
    
    @IBInspectable public var headerText: String?  {
        set {
            headerLabel?.setText(text: newValue, color: .floatingLabelColor)
            headerLabel?.letterSpace = Constants.Header.letterSpacing
        }
        get { return headerLabel?.getText() }
    }
    
    @IBInspectable public var placeholderColor: UIColor {
        set {
            if let placeholder = placeholderText {
                textField?.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                      attributes: [.font : FontFamily.Gerbera.light.font(size: 15),
                                                                                   .foregroundColor: newValue])
            }
        }
        get { return UIColor.placeholderColor  }
    }
    
    @IBInspectable public var placeholderText: String? {
        set { textField?.placeholder = newValue }
        get { return textField?.placeholder }
    }
    
    @IBInspectable var isSecure: Bool = false
    
    /// Delegate
    public weak var delegate: FloatingLabelTextFieldDelegate?
       
    /// Events listener
    public var events: [EventListener] = []
    
    /// Views
    internal var headerLabel: AttributedLabel?
    internal var descriptionLabel: AttributedLabel?
    internal var textField: UITextField?
    internal var separatorView: UIView?
    internal var stateView: UIView?
    internal var extraViewsContainer: UIView?
    
    /// Constraints
    internal var stateViewConstraintWidth: NSLayoutConstraint?
    internal var headerLabelConstraintTop: NSLayoutConstraint?
    
    /// State view width
    internal lazy var stateViewWidth: CGFloat = 0
    
    /// Animation duration
    private let headerAnimDuration: TimeInterval = Constants.Header.animDuration
    
    /// Letter spacing
    private lazy var secureTextLetterSpacing: CGFloat = Constants.TextField.secureLetterSpacing
    private lazy var unsecureTextLetterSpacing: CGFloat = Constants.TextField.unsecureLetterSpacing
    
    /// Text
    private lazy var unsecureText = String()
    private lazy var secureText = String()
    
    var isFloatingLabelShown = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
}

// MARK: - Setup
extension FloatingLabelTextField {
    
    /// Basic configuration and view creation
    private func setUpView() {
        backgroundColor = .clear
        
        // Registers all the library fonts
        UIFont.registerLibraryFonts()
        
        // Creates all the views
        createHeaderLabel()
        createTextField()
        createSeparator()
        createStateView()
        createDescriptionLabel()
    }
    
    /// Creates header label
    private func createHeaderLabel() {
        // Init and add header as a subview
        headerLabel = AttributedLabel()
        headerLabel?.alpha = 0
        headerLabel?.font = FontFamily.Gerbera.light.font(size: Constants.Header.fontSize)
        headerLabel?.sizeToFit()
        headerLabel?.translatesAutoresizingMaskIntoConstraints =  false
        addSubview(headerLabel!)
        
        // Applies constraints for header label
        constraints(for: headerLabel)
    }
    
    /// Creates text filed
    private func createTextField() {
        // Init and add text field as a subview
        textField = UITextField()
        textField?.delegate = self
        textField?.font = FontFamily.Gerbera.medium.font(size: Constants.TextField.fontSize)
        textField?.textColor = UIColor.white
        textField?.rightViewMode = .always
        textField?.translatesAutoresizingMaskIntoConstraints =  false
        textField?.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        addSubview(textField!)
        
        // Applies constraints for text field
        constraints(for: textField)
    }
    
    /// Creates separator view
    private func createSeparator() {
        // Init and add separator as a subview
        separatorView = UIView()
        separatorView?.backgroundColor = separatorColor
        separatorView?.translatesAutoresizingMaskIntoConstraints =  false
        addSubview(separatorView!)
        
        // Applies constraints for separator
        constraints(for: separatorView)
    }
    
    /// Creates state view
    private func createStateView() {
        // Init and add state view as a subview
        stateView = UIView()
        stateView?.translatesAutoresizingMaskIntoConstraints =  false
        stateViewWidth = frame.width
        addSubview(stateView!)
        
        // Applies constraints for state view
        constraints(for: stateView)
    }
    
    /// Creates description label
    private func createDescriptionLabel() {
        // Init and add description label as a subview
        descriptionLabel = AttributedLabel()
        descriptionLabel?.sizeToFit()
        descriptionLabel?.textColor = .white
        descriptionLabel?.font = FontFamily.Gerbera.medium.font(size: Constants.Description.fontSize)
        descriptionLabel?.translatesAutoresizingMaskIntoConstraints =  false
        addSubview(descriptionLabel!)
        
        // Applies constraints for description label
        constraints(for: descriptionLabel)
    }
}

// MARK: - Helper methods
extension FloatingLabelTextField {
    
    /// Handles inputed text.
    /// - Parameter text: Relevant text.
    private func handleText(_ text: String?) {
        // Notifies that text has been changed
        events.forEach { $0(.didTextChanged(self)) }
        
        // Toggle header state (show or hide)
        if let inputedText = text {
            let symbolsCount = inputedText.count
            if symbolsCount >= 1 && !isFloatingLabelShown { toggleHeaderLabel() }
            else if symbolsCount < 1 { toggleHeaderLabel() }
        }
        
        // Update secure line depending on text state
        if let delegate = self.delegate {
            let (state, descr, color) = delegate.state(for: self)
            updateSecureLine(to: state, text: descr, color: color)
        }
    }
    
    /// Toggle header label state
    private func toggleHeaderLabel() {
        guard let headerLabel = headerLabel else { return }
        
        // Updates floating label state
        isFloatingLabelShown = !isFloatingLabelShown
        
        // Calculate correct header position
        let currFrame = headerLabel.frame
        let value = !isFloatingLabelShown ? currFrame.origin.y + currFrame.height : currFrame.origin.y - currFrame.height
        
        // Updates constraint value
        headerLabelConstraintTop?.constant = value
        
        // Animate view with already changed constraint value
        UIView.animateKeyframes(withDuration: headerAnimDuration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.headerAnimDuration) {
                headerLabel.frame = CGRect(x: 0, y: value, width: currFrame.width, height: currFrame.height)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.headerAnimDuration / 2) {
                headerLabel.alpha = !self.isFloatingLabelShown ? 0 : 1
            }
            
        }, completion: nil)
    }
    
    /// Sets new text and adjusts letter spacing.
    /// - Parameter text: New text.
    private func setAttributedText(_ text: String) {
        guard let textField = textField else { return }
        
        // Update letter spacing depending on text format (secure or not)
        let letterSpacing = isSecure ? secureTextLetterSpacing : unsecureTextLetterSpacing
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern,
                                      value: letterSpacing,
                                      range: NSRange(location: 0, length: attributedString.length))
        textField.attributedText = attributedString
    }
    
    /// Refreshes current text.
    /// - Parameter text: New unsecure text.
    private func refreshSecureText(_ text: String) {
        unsecureText = text
        // Refreshs secure text
        secureText.removeAll()
        // Fills string with secure chars
        for _ in unsecureText {  secureText += Constants.secureChar }
    }
}

// MARK: - Configuration
extension FloatingLabelTextField {
    
    /// Switches text format to secure or not.
    /// - Parameter secure: Represents should text be secure or not .
    public func switchTextFormat(secure: Bool) {
        // Toggles secure state
        isSecure = !isSecure
        
        // Save current text selection
        let selectedTextRange = textField?.selectedTextRange
        
        // Updates text with new state
        setAttributedText(secure ? secureText : unsecureText)
        
        if let selectedTextRange = selectedTextRange {
            textField?.selectedTextRange = selectedTextRange
        }
    }
       
    public func updateSecureLine(to state: InputTextState, text: String?, color: UIColor?) {
        guard let stateView = stateView else { return }
       
        // Updates line width depending on state
        stateViewConstraintWidth?.constant = state.rawValue * stateViewWidth
       
        // If state is idle then hide descr label
        // otherwise make it visible
        if state == .idle {
            descriptionLabel?.textColor = .white
            descriptionLabel?.isHidden = true
            return
        } else {
            descriptionLabel?.isHidden = false
        }
       
        // Sets new desc text and updates state view color
        if let descrLabel = descriptionLabel {
            descrLabel.text = text
            descrLabel.textColor = color
            stateView.backgroundColor = color
        }
    }

    /// Returns current text state
    public func isSecute() -> Bool { return isSecure }

    /// Sets keyboard type.
    /// - Parameter type: UIKeyboardType to be setted.
    public func setKeyboardType(_ type: UIKeyboardType) {
        textField?.keyboardType = type
    }
    
    /// Sets text field autocorrection type.
    /// - Parameter type: UITextAutocorrectionType to be setted.
    public func setAutocorrectionType(_ type: UITextAutocorrectionType) {
        textField?.autocorrectionType = type
    }

    /// Get current text in unsecure format
    public func getText() -> String {
        return unsecureText
    }
    
    /// Updates current text with the new one.
    /// - Parameter text: New text.
    public func setText(_ text: String) {
       // Refreshes secure text
       refreshSecureText(text)
       // Sets new text
       setAttributedText(isSecure ? secureText : unsecureText)
       // Handles new text
       handleText(unsecureText)
    }
}

// MARK: - Extra views
extension FloatingLabelTextField {
    
    /// Add right label to the text field with specific color.
    /// - Parameters:
    ///   - text: Label's text.
    ///   - color: Text color.
    public func addRightText(_ text: String, color: UIColor) {
        // Init and button with basic configs
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: frame.height, height: frame.height))
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = FontFamily.Gerbera.light.font(size: Constants.RightLabel.fontSize)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color.darker(), for: .highlighted)
        button.sizeToFit()
        button.addTarget(self, action: #selector(onRightViewClick(_:)), for: .touchDown)
        
        // Sets button as text field's right view
        textField?.rightViewMode = .always
        textField?.rightView = button
    }
    
    /// Add images to the right of the text field.
    /// - Parameters:
    ///   - images: Array of images.
    public func addRightImages(_ images: [UIImage], spacing: CGFloat? = nil) {
        let viewHeight: CGFloat = frame.height
        let containerView = UIView()
        let imageSpacing = (spacing == nil ? Constants.RightImage.spacing : spacing!)
        var conainerViewWidth: CGFloat = 0
        var i = 0
        
        // Creates buttons in the loop and adds to the container
        while i < images.count {
            let spacing = (i != 0 ? imageSpacing : 0)
            let button = UIButton(frame: .zero)
            button.frame.origin.x = (containerView.subviews.last?.frame.maxX ?? 0) + spacing
            button.tag = i
            button.sizeToFit()
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(images[i], for: .normal)
            button.addTarget(self, action: #selector(onRightViewClick(_:)), for: .touchDown)
            conainerViewWidth = conainerViewWidth + button.frame.width + spacing
            containerView.addSubview(button)
            button.frame.origin.y = viewHeight / 2 - button.frame.height / 2
            i = i + 1
        }
        
        // Updates container view size
        containerView.frame = CGRect(x: 0, y: 0, width: conainerViewWidth, height: viewHeight)
        
        // Sets button as text field's right view
        textField?.rightViewMode = .always
        textField?.rightView = containerView
    }
    
    /// Handles click on extra view.
    /// - Parameter button: Button that has been clicked.
    @objc private func onRightViewClick(_ button: UIButton) {
        // Gets tag that represent button's index in the parent view
        let index = button.tag
        if let rightView = textField?.rightView {
            if let button = rightView as? UIButton {
                // Notifies for button pressed event
                events.forEach { $0(.didRightButtonPressed(self, index: index, button: button)) }
                
            } else if let subviews = textField?.rightView?.subviews, subviews.count > 0,
                let button = subviews[index] as? UIButton {
                // Notifies for button pressed event
                events.forEach { $0(.didRightButtonPressed(self, index: index, button: button)) }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension FloatingLabelTextField: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        // Notifies that editing has been finised
        events.forEach { $0(.didEndEditing(self)) }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // Notifies that editing has been started
        events.forEach { $0(.didStartEditing(self)) }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        // If we should not hide inputed text then return immediately
        guard isSecure else { return true }
        
        // Creates new instance of secure text
        var secureText = String()
        var selectionPosition = -1
        if let selectedTextIndexes = textField.selectedTextIndexes() {
            let startIndex = selectedTextIndexes.startIndex
            let endIndex = selectedTextIndexes.endIndex
            let charsToRemove = unsecureText.distance(from: startIndex, to: endIndex)
            let lastSelectedCharIndex = unsecureText.distance(from: unsecureText.startIndex, to: endIndex)
            
            // Determinate caret position after text has been cropped
            selectionPosition = lastSelectedCharIndex - charsToRemove
            
            // Replaces selected range with emptiness
            unsecureText.replaceSubrange(startIndex..<endIndex, with: "")
        } else {
            // Gets current caret position
            if let selectedTextRange = textField.selectedTextRange {
                selectionPosition = textField.offset(from: textField.beginningOfDocument, to: selectedTextRange.start) + 1
            }
            
            // Determinate offset to be text changed for
            let offsetToUpdate = unsecureText.index(unsecureText.startIndex, offsetBy: range.location)
            if string.isEmpty {
                unsecureText.remove(at: offsetToUpdate)
                return true
            } else {
                if string.count > 1 {
                    for ch in string.reversed() {
                        unsecureText.insert(ch, at: offsetToUpdate)
                    }
                } else { unsecureText.insert(string.first!, at: offsetToUpdate) }
            }
        }
        
        // Fills string with secure chars
        for _ in unsecureText {  secureText += Constants.secureChar }
        
        // Save secure text
        self.secureText = secureText
        
        // Update text with secure onte
        setAttributedText(secureText)
        
        // Sets correct caret position after manipulations with the text
        if selectionPosition != -1, let caretPosition = textField.position(from: textField.beginningOfDocument,
                                                                           offset: selectionPosition) {
            textField.selectedTextRange = textField.textRange(from: caretPosition, to: caretPosition)
        }
        
        // Handle inputed text
        handleText(unsecureText)
        
        // Notifies that text has been changed
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
        return false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // Refreshes secure text if needed
        if !isSecure { refreshSecureText(text) }
        else if !secureText.isEmpty { secureText.removeLast() }
        
        // Handle new text
        handleText(text)
    }
}
