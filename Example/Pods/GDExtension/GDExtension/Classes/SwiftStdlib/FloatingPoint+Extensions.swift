//
//  FloatingPoint+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension FloatingPoint {

    /// GDExtension: Absolute value of number.
    var abs: Self {
        return Swift.abs(self)
    }

    /// GDExtension: Check if number is positive.
    var isPositive: Bool {
        return self > 0
    }

    /// GDExtension: Check if number is negative.
    var isNegative: Bool {
        return self < 0
    }

    #if canImport(Foundation)
    /// GDExtension: Ceil of number.
    var ceil: Self {
        return Foundation.ceil(self)
    }
    #endif

    /// GDExtension: Radian value of degree input.
    var degreesToRadians: Self {
        return Self.pi * self / Self(180)
    }

    #if canImport(Foundation)
    /// GDExtension: Floor of number.
    var floor: Self {
        return Foundation.floor(self)
    }
    #endif

    /// GDExtension: Degree value of radian input.
    var radiansToDegrees: Self {
        return self * Self(180) / Self.pi
    }

}

// MARK: - Operators

infix operator ±
/// GDExtension: Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: number
///   - rhs: number
/// - Returns: tuple of plus-minus operation ( 2.5 ± 1.5 -> (4, 1)).
// swiftlint:disable:next identifier_name
func ± <T: FloatingPoint> (lhs: T, rhs: T) -> (T, T) {
    // http://nshipster.com/swift-operators/
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±
/// GDExtension: Tuple of plus-minus operation.
///
/// - Parameter int: number
/// - Returns: tuple of plus-minus operation (± 2.5 -> (2.5, -2.5)).
// swiftlint:disable:next identifier_name
public prefix func ± <T: FloatingPoint> (number: T) -> (T, T) {
    // http://nshipster.com/swift-operators/
    return 0 ± number
}
