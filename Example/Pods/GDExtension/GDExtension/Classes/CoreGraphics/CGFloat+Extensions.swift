//
//  CGFloat+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2016 GDExtension
//

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif

// MARK: - Properties
public extension CGFloat {

    /// GDExtension: Absolute of CGFloat value.
    var abs: CGFloat {
        return Swift.abs(self)
    }

    /// GDExtension: Ceil of CGFloat value.
    var ceil: CGFloat {
        return Foundation.ceil(self)
    }

    /// GDExtension: Radian value of degree input.
    var degreesToRadians: CGFloat {
        return .pi * self / 180.0
    }

    /// GDExtension: Floor of CGFloat value.
    var floor: CGFloat {
        return Foundation.floor(self)
    }

    /// GDExtension: Check if CGFloat is positive.
    var isPositive: Bool {
        return self > 0
    }

    /// GDExtension: Check if CGFloat is negative.
    var isNegative: Bool {
        return self < 0
    }

    /// GDExtension: Int.
    var int: Int {
        return Int(self)
    }

    /// GDExtension: Float.
    var float: Float {
        return Float(self)
    }

    /// GDExtension: Double.
    var double: Double {
        return Double(self)
    }

    /// GDExtension: Degree value of radian input.
    var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }

}

#endif
