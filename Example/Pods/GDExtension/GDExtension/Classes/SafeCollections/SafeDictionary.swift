//
//  SafeDictionary.swift
//  GDExtension
//
//  Created by Objc on 2019/8/21.
//

import UIKit


open class SafeDictionary<Key: Hashable, Value: Any>: NSObject{
    fileprivate let lock = ReadWriteLockFactory().newLock()
    fileprivate var dictionary = [Key:Value]()
}
// MARK: - Properties
public extension SafeDictionary {
    var isEmpty: Bool {
        var result = true
        lock.readLock { result = self.dictionary.isEmpty }
        return result
    }
    
    var count: Int {
        var result = 0
        lock.readLock { result = self.dictionary.count }
        return result
    }
}

// MARK: - Method for read
public extension SafeDictionary{
    func valueForKey(_ key: Key) -> Value? {
        var result: Value?
        lock.readLock { result = self.dictionary.index(forKey: key) as? Value }
        return result
    }
    func updateValue(_ value: Value, forKey key: Key) -> Value? {
        var result: Value?
        lock.readLock { result = self.dictionary.updateValue(value, forKey: key) }
        return result
    }
    
    func removeValue(forKey key: Key) -> Value? {
        var result: Value?
        lock.readLock { result = self.dictionary.removeValue(forKey: key)}
        return result
    }
}
// MARK: - Method for write
public extension SafeDictionary{
    
    
    func removeAll(keepingCapacity keepCapacity: Bool = false) {
        lock.writeLock {
            self.dictionary.removeAll(keepingCapacity: keepCapacity)
        }
    }
}

// MARK: - Method for subscripting
public extension SafeDictionary{
    subscript (key: Key) -> Value? {
        get {
            var result: Value?
            
            lock.readLock {
                result = self.dictionary[key]
            }
            
            return result
        }
        set {
            
            lock.writeLock {
                self.dictionary[key] = newValue
            }
        }
    }
}

