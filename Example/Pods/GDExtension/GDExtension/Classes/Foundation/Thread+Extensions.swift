//
//  Thread+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

import Dispatch
import Foundation

// MARK: - Global functions

/// Runs a block on main thread.
///
/// - Parameter block: Block to be executed.
public func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

/// Runs a block in background.
///
/// - Parameter block: block Block to be executed.
public func runInBackground(_ block: @escaping () -> Void) {
    DispatchQueue.global().async {
        block()
    }
}
