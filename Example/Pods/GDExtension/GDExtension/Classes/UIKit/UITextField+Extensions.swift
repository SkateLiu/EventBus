//
//  UITextField+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Enums
public extension GDReference where Base:  UITextField {

    /// GDExtension: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    enum TextType {
        /// UITextField is used to enter email addresses.
        case emailAddress

        /// UITextField is used to enter passwords.
        case password

        /// UITextField is used to enter generic text.
        case generic
    }

}

// MARK: - Methods
public extension GDReference where Base:  UITextField {

    /// GDExtension: Set textField for common text types.
    var textType: TextType {
        get {
            if base.keyboardType == .emailAddress {
                return .emailAddress
            } else if base.isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                base.keyboardType = .emailAddress
                base.autocorrectionType = .no
                base.autocapitalizationType = .none
                base.isSecureTextEntry = false
                base.placeholder = "Email Address"

            case .password:
                base.keyboardType = .asciiCapable
                base.autocorrectionType = .no
                base.autocapitalizationType = .none
                base.isSecureTextEntry = true
                base.placeholder = "Password"

            case .generic:
                base.isSecureTextEntry = false
            }
        }
    }

    /// GDExtension: Check if text field is empty.
    var isEmpty: Bool {
        return base.text?.isEmpty == true
    }

    /// GDExtension: Return text with no spaces or new lines in beginning and end.
    var trimmedText: String? {
        return base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// GDExtension: Check if textFields text is a valid email format.
    ///
    ///		textField.text = "john@doe.com"
    ///		textField.hasValidEmail -> true
    ///
    ///		textField.text = "GDExtension"
    ///		textField.hasValidEmail -> false
    ///
    var hasValidEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return base.text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    
    /// GDExtension: Clear text.
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }
    
    /// GDExtension: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = base.placeholder, !holder.isEmpty else { return }
        base.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    /// GDExtension: Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: base.frame.height))
        base.leftView = paddingView
        base.leftViewMode = .always
    }
    
    /// GDExtension: Add padding to the left of the textfield rect.
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        base.leftView = imageView
        base.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        base.leftViewMode = .always
    }

}

// MARK: - Properties
public extension UITextField {

    /// GDExtension: Left view tint color.
    @IBInspectable var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
    /// GDExtension: Right view tint color.
    @IBInspectable var rightViewTintColor: UIColor? {
        get {
            guard let iconView = rightView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = rightView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

}

#endif
