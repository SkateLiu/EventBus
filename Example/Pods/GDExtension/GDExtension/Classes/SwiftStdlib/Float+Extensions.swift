//
//  Float+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

// MARK: - Properties
public extension Float {

    /// GDExtension: Int.
    var int: Int {
        return Int(self)
    }

    /// GDExtension: Double.
    var double: Double {
        return Double(self)
    }

    #if canImport(CoreGraphics)
    /// GDExtension: CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    #endif

}

// MARK: - Operators

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// GDExtension: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base float.
///   - rhs: exponent float.
/// - Returns: exponentiation result (4.4 ** 0.5 = 2.0976176963).
func ** (lhs: Float, rhs: Float) -> Float {
    // http://nshipster.com/swift-operators/
    return pow(lhs, rhs)
}

prefix operator √
/// GDExtension: Square root of float.
///
/// - Parameter float: float value to find square root for
/// - Returns: square root of given float.
// swiftlint:disable:next identifier_name
public prefix func √ (float: Float) -> Float {
    // http://nshipster.com/swift-operators/
    return sqrt(float)
}
