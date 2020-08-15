//
//  UISwitch+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit)  && os(iOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base:  UISwitch {

    /// GDExtension: Toggle a UISwitch
    ///
    /// - Parameter animated: set true to animate the change (default is true)
    func toggle(animated: Bool = true) {
        base.setOn(!base.isOn, animated: animated)
    }

}

#endif
