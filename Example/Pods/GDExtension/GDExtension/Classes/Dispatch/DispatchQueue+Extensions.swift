//
//  DispatchQueue+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(Dispatch)
import Dispatch

// MARK: - Properties
public extension DispatchQueue {

    /// GDExtension: A Boolean value indicating whether the current
    /// dispatch queue is the main queue.
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }

}

// MARK: - Methods
public extension DispatchQueue {

    /// GDExtension: Returns a Boolean value indicating whether the current
    /// dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue is the specified queue, otherwise `false`.
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
    
    /// GDExtension:  Runs the function after x seconds
    ///
    /// - Parameter
    ///     - second: the time after to call
    ///     - closure: closure when timeout to call
    ///
    static func after(_ second: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

}

// MARK: - DispatchOnce
public extension DispatchQueue {
    private static var _onceToken = [String]()
    
    /// GDExtension: Once queue
    /// - Parameter queue: The token of class
    static func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        
        defer
        {
            objc_sync_exit(self)
        }
        
        if _onceToken.contains(token)
        {
            return
        }
        
        _onceToken.append(token)
        block()
    }
}
#endif
