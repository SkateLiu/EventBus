//
//  UISearchBar+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && os(iOS)
import UIKit

// MARK: - Properties
public extension GDReference where Base: UISearchBar {

    /// GDExtension: Text field inside search bar (if applicable).
    var textField: UITextField? {
        let subViews = base.subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    /// GDExtension: Text with no spaces or new lines in beginning and end (if applicable).
    var trimmedText: String? {
        return base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

// MARK: - Methods
public extension GDReference where Base: UISearchBar {

    /// GDExtension: Clear text.
    func clear() {
        base.text = ""
    }

}

#endif
