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
        get { return UIColor.separatorColor }
    }
    
    @IBInspectable public var headerColor: UIColor {
        set { headerLabel?.textColor = newValue }
        get { return UIColor.floatingLabelColor  }
    }
    
    @IBInspectable public var headerText: String?  {
        set {
            headerLabel?.setText(text: newValue, color: .floatingLabelColor)
            headerLabel?.letterSpace = -0.2
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
    
    ///Animation
    private let animDuration: TimeInterval = 0.3
    
    ///Views
    internal var stateViewConstraintWidth: NSLayoutConstraint?
    internal var headerLabelConstraintTop: NSLayoutConstraint?
    internal var headerLabel: AttributedLabel?
    internal var descriptionLabel: AttributedLabel?
    internal var textField: UITextField?
    internal var separatorView: UIView?
    internal var stateView: UIView?
    internal var extraViewsContainer: UIView?
    
    ///Letter spacing
    private lazy var secureTextLetterSpacing: CGFloat = 5
    private lazy var unsecureTextLetterSpacing: CGFloat = -0.6
    
    ///Text
    private lazy var unsecureText = String()
    private lazy var secureText = String()
    
    ///Size
    internal lazy var stateViewWidth: CGFloat = 0
    
    ///Delegate
    public weak var delegate: FloatingLabelTextFieldDelegate?
    
    ///Events
    public var events: [EventListener] = []
    
    var isFloatingShown = false
    
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
extension FloatingLabelTextField {
    
    private func configure() {
        backgroundColor = .clear
        
        UIFont.registerLibraryFonts()
        
        createHeaderLabel()
        createTextField()
        createSeparator()
        createStateView()
        createDescriptionLabel()
    }
    
    private func createHeaderLabel() {
        headerLabel = AttributedLabel()
        headerLabel?.alpha = 0
        headerLabel?.font = FontFamily.Gerbera.light.font(size: 12)
        headerLabel?.sizeToFit()
        headerLabel?.translatesAutoresizingMaskIntoConstraints =  false
        addSubview(headerLabel!)
        
        constraints(for: headerLabel)
    }
    
    private func createTextField() {
        textField = UITextField()
        textField?.delegate = self
        textField?.font = FontFamily.Gerbera.medium.font(size: 18)
        textField?.textColor = UIColor.white
        textField?.rightViewMode = .always
        textField?.translatesAutoresizingMaskIntoConstraints =  false
        textField?.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        addSubview(textField!)
        
        constraints(for: textField)
    }
    
    private func createSeparator() {
        separatorView = UIView()
        separatorView?.backgroundColor = separatorColor
        separatorView?.translatesAutoresizingMaskIntoConstraints =  false
        addSubview(separatorView!)
        
        constraints(for: separatorView)
    }
    
    private func createStateView() {
        stateView = UIView()
        stateView?.translatesAutoresizingMaskIntoConstraints =  false
        stateViewWidth = frame.width
        addSubview(stateView!)
        
        constraints(for: stateView)
    }
    
    private func createDescriptionLabel() {
        descriptionLabel = AttributedLabel()
        descriptionLabel?.sizeToFit()
        descriptionLabel?.textColor = .white
        descriptionLabel?.font = FontFamily.Gerbera.medium.font(size: 10)
        descriptionLabel?.translatesAutoresizingMaskIntoConstraints =  false
        addSubview(descriptionLabel!)
        
        constraints(for: descriptionLabel)
    }
    
    private func handleText(_ text: String?) {
        events.forEach { $0(.didTextChanged(self)) }
        
        if let inputedText = text {
            let symbolsCount = inputedText.count
            if symbolsCount >= 1 && !isFloatingShown { toggleHeaderLabel() }
            else if symbolsCount < 1 { toggleHeaderLabel() }
        }
        
        if let delegate = self.delegate {
            let (state, descr, color) = delegate.state(for: self)
            updateSecureLine(to: state, text: descr, color: color)
        }
    }
    
    private func toggleHeaderLabel() {
        guard let headerLabel = headerLabel else { return }
        isFloatingShown = !isFloatingShown
        
        let currFrame = headerLabel.frame
        let value = !isFloatingShown ? currFrame.origin.y + currFrame.height : currFrame.origin.y - currFrame.height
        headerLabelConstraintTop?.constant = value
        
        UIView.animateKeyframes(withDuration: animDuration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.animDuration) {
                headerLabel.frame = CGRect(x: 0, y: value, width: currFrame.width, height: currFrame.height)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.animDuration / 2) {
                headerLabel.alpha = !self.isFloatingShown ? 0 : 1
            }
            
        }, completion: nil)
    }
    
    public func switchTextFormat(secure: Bool) {
        isSecure = !isSecure
        setAttributedText(text: secure ? secureText : unsecureText)
    }
    
    public func updateSecureLine(to state: InputTextState, text: String?, color: UIColor?) {
        guard let stateView = stateView else { return }
        
        stateViewConstraintWidth?.constant = state.rawValue * stateViewWidth
        if state == .idle {
            descriptionLabel?.textColor = .white
            descriptionLabel?.isHidden = true
            return
            
        } else { descriptionLabel?.isHidden = false }
        
        if let descrLabel = descriptionLabel {
            descrLabel.text = text
            descrLabel.textColor = color
            stateView.backgroundColor = color
        }
    }
    
    public func isSecute() -> Bool { return isSecure }
    
    public func setKeyboardType(_ type: UIKeyboardType) {
         textField?.keyboardType = type
    }
    
    public func getText() -> String {
        return unsecureText
    }
    
    public func setText(_ text: String) {
        updateText(text: text)
        setAttributedText(text: isSecure ? secureText : unsecureText)
        handleText(unsecureText)
    }
    
    private func setAttributedText(text: String) {
        guard let textField = textField else { return }
        
        let letterSpacing = isSecure ? secureTextLetterSpacing : unsecureTextLetterSpacing
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern,
                                      value: letterSpacing,
                                      range: NSRange(location: 0, length: attributedString.length))
        textField.attributedText = attributedString
    }
    
    private func updateText(text: String) {
        unsecureText = text
        secureText.removeAll()
        for _ in unsecureText {  secureText += "●" }
    }
}

// MARK: - Extra views
extension FloatingLabelTextField {
    
    public func addRightExtraView(text: String, color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: frame.height, height: frame.height))
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = FontFamily.Gerbera.light.font(size: 15)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color.darker(), for: .highlighted)
        button.sizeToFit()
        button.addTarget(self, action: #selector(onExtraViewClick(_:)), for: .touchDown)
        textField?.rightView = button
    }
    
    public func addRightExtraViews(images: [UIImage]) {
        let viewHeight: CGFloat = frame.height, viewSpacing: CGFloat = 8
        let containerView = UIView()
        var i = 0, conainerViewWidth: CGFloat = 0
        
        while i < images.count {
            let image = images[i]
            let spacing = (i != 0 ? viewSpacing : 0)
            let buttonX = (containerView.subviews.last?.frame.maxX ?? 0) + spacing
            let button = UIButton(frame: .zero)
            button.frame.origin.x = buttonX
            button.tag = i
            button.sizeToFit()
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(onExtraViewClick(_:)), for: .touchDown)
            conainerViewWidth = conainerViewWidth + button.frame.width + spacing
            containerView.addSubview(button)
            button.frame.origin.y = viewHeight / 2 - button.frame.height / 2
            i = i + 1
        }
        
        containerView.frame = CGRect(x: 0, y: 0, width: conainerViewWidth, height: viewHeight)
        textField?.rightView = containerView
    }
    
    @objc private func onExtraViewClick(_ button: UIButton) {
        let index = button.tag
        if let rightView = textField?.rightView {
            if let button = rightView as? UIButton {
                events.forEach { $0(.didExtraButtonPressed(floatingTextField: self, index: index, button: button)) }
                
            } else if let subviews = textField?.rightView?.subviews, subviews.count > 0,
                let button = subviews[index] as? UIButton {
                events.forEach { $0(.didExtraButtonPressed(floatingTextField: self, index: index, button: button)) }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension FloatingLabelTextField: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        events.forEach { $0(.didEndEditing(self)) }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        events.forEach { $0(.didStartEditing(self)) }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard isSecure else { return true }
        
        var secureText = String()
        let offsetToUpdate = unsecureText.index(unsecureText.startIndex, offsetBy: range.location)
        
        if string.isEmpty {
            unsecureText.remove(at: offsetToUpdate)
            return true
        } else { unsecureText.insert(string.first!, at: offsetToUpdate) }
        
        for _ in unsecureText {  secureText += "●" }
        self.secureText = secureText
        
        setAttributedText(text: secureText)
        handleText(unsecureText)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
        
        return false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if !isSecure { updateText(text: text) }
        else if !secureText.isEmpty { secureText.removeLast() }
        handleText(text)
    }
}
