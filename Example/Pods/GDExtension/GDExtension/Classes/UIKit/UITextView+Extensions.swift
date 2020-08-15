//
//  UITextView+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base:  UITextView {

    /// GDExtension: Clear text.
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }

    /// GDExtension: Scroll to the bottom of text view
    func scrollToBottom() {
        // swiftlint:disable:next legacy_constructor
        let range = NSMakeRange((base.text as NSString).length - 1, 1)
        base.scrollRangeToVisible(range)
    }

    /// GDExtension: Scroll to the top of text view
    func scrollToTop() {
        // swiftlint:disable:next legacy_constructor
        let range = NSMakeRange(0, 1)
        base.scrollRangeToVisible(range)
    }

    /// GDExtension: Wrap to the content (Text / Attributed Text).
    func wrapToContent() {
        base.contentInset = UIEdgeInsets.zero
        base.scrollIndicatorInsets = UIEdgeInsets.zero
        base.contentOffset = CGPoint.zero
        base.textContainerInset = UIEdgeInsets.zero
        base.textContainer.lineFragmentPadding = 0
        base.sizeToFit()
    }

}

#endif
