//
//  NSPredicate+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(Foundation)
import Foundation

// MARK: - Properties
public extension NSPredicate {

    /// GDExtension: Returns a new predicate formed by NOT-ing the predicate.
    var not: NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

}

// MARK: - Methods
public extension NSPredicate {

    /// GDExtension: Returns a new predicate formed by AND-ing the argument to the predicate.
    ///
    /// - Parameter predicate: NSPredicate
    /// - Returns: NSCompoundPredicate
    func and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    /// GDExtension: Returns a new predicate formed by OR-ing the argument to the predicate.
    ///
    /// - Parameter predicate: NSPredicate
    /// - Returns: NSCompoundPredicate
    func or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }

}

// MARK: - Operators
public extension NSPredicate {

    /// GDExtension: Returns a new predicate formed by NOT-ing the predicate.
    /// - Parameters: rhs: NSPredicate to convert.
    /// - Returns: NSCompoundPredicate
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.not
    }

    /// GDExtension: Returns a new predicate formed by AND-ing the argument to the predicate.
    ///
    /// - Parameters:
    ///   - lhs: NSPredicate.
    ///   - rhs: NSPredicate.
    /// - Returns: NSCompoundPredicate
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.and(rhs)
    }

    /// GDExtension: Returns a new predicate formed by OR-ing the argument to the predicate.
    ///
    /// - Parameters:
    ///   - lhs: NSPredicate.
    ///   - rhs: NSPredicate.
    /// - Returns: NSCompoundPredicate
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.or(rhs)
    }

    /// GDExtension: Returns a new predicate formed by remove the argument to the predicate.
    ///
    /// - Parameters:
    ///   - lhs: NSPredicate.
    ///   - rhs: NSPredicate.
    /// - Returns: NSCompoundPredicate
    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }

}

#endif
