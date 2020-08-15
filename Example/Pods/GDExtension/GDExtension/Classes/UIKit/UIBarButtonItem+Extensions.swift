//
//  UIBarButtonItem+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base: UIBarButtonItem {

    /// GDExtension: Add Target to UIBarButtonItem
    ///
    /// - Parameters:
    ///   - target: target.
    ///   - action: selector to run when button is tapped.
    func addTargetForAction(_ target: AnyObject, action: Selector) {
        base.target = target
        base.action = action
    }

}

public extension UIBarButtonItem{
    
    /// Create an UIBarButtonItem with type setted to FlexibleSpace or FixedSpace.
    ///
    /// - Parameters:
    ///   - space: Must be FlexibleSpace or FixedSpace, otherwise a FlexibleSpace UIBarButtonItem will be created.
    ///   - width: To use only if space is setted to FixedSpace, and it will be the width of it.
    convenience init(barButtonSpaceType space: UIBarButtonItem.SystemItem, width: CGFloat = 0.0) {
        if space == .fixedSpace || space == .flexibleSpace {
            self.init(barButtonSystemItem: space, target: nil, action: nil)
            
            if space == .fixedSpace {
                self.width = width
            }
        } else {
            self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
    }
}

#endif
