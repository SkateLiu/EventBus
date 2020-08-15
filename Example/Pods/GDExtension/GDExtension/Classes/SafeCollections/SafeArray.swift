//
//  SafeArray.swift
//  GDExtension
//
//  Created by Objc on 2019/8/21.
//

import UIKit

// MARK: - SafeArray
open class SafeArray<Element>:NSObject {
    fileprivate let lock = ReadWriteLockFactory().newLock()
    fileprivate var array = [Element]()
}

// MARK: - Properties
public extension SafeArray {

    var first: Element? {
        var result: Element?
        lock.readLock {
            result = self.array.first
        }
        return result
    }

    var last: Element? {
        var result: Element?
        lock.readLock {
            result = self.array.last
        }
        return result
    }

    var count: Int {
        var result = 0
        lock.readLock {
            result = self.array.count
        }
        return result
    }

    var isEmpty: Bool {
        var result = false
        lock.readLock {
            result = self.array.isEmpty
        }
        return result
    }
}

// MARK: - Method for read
public extension SafeArray {
    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        lock.readLock {
            result = self.array.first(where: predicate)
        }
        return result
    }

    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        lock.readLock {
            result = self.array.filter(isIncluded)
        }
        return result
    }

    func index(where predicate: (Element) -> Bool) -> Int? {
        var result: Int?
        lock.readLock {
            result = self.array.index(where: predicate)
        }
        return result
    }

    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        lock.readLock {
            result = self.array.sorted(by: areInIncreasingOrder)
        }
        return result
    }

    func compactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        lock.readLock {
            result = self.array.compactMap(transform)
        }
        return result
    }

    func forEach(_ body: (Element) -> Void) {
        lock.readLock {
            self.array.forEach(body)
        }
    }

    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        lock.readLock {
            result = self.array.contains(where: predicate)
        }
        return result
    }
}

// MARK: - Method for write
public extension SafeArray {

    func append( _ element: Element) {
        lock.writeLock {
            self.array.append(element)
        }
    }

    func append( _ elements: [Element]) {
        lock.writeLock {
            self.array += elements
        }
    }

    func insert( _ element: Element, at index: Int) {
        lock.writeLock {
            self.array.insert(element, at: index)
        }
    }

    func remove(at index: Int, completion: ((Element) -> Void)? = nil) {
        lock.writeLock {
            let element = self.array.remove(at: index)

            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }

    func remove(where predicate: @escaping (Element) -> Bool, completion: ((Element) -> Void)? = nil) {
        lock.writeLock {
            guard let index = self.array.index(where: predicate) else { return }
            let element = self.array.remove(at: index)

            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }

    func removeAll(completion: (([Element]) -> Void)? = nil) {
        lock.writeLock {
            let elements = self.array
            self.array.removeAll()

            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }
}

// MARK: - Method for subscripting
public extension SafeArray {

    subscript(index: Int) -> Element? {
        get {
            var result: Element?

            lock.readLock {
                guard self.array.startIndex..<self.array.endIndex ~= index else { return }
                result = self.array[index]
            }

            return result
        }
        set {
            guard let newValue = newValue else { return }

            lock.writeLock {
                self.array[index] = newValue
            }
        }
    }
}

// MARK: - Equatable
public extension SafeArray where Element: Equatable {

    func contains(_ element: Element) -> Bool {
        var result = false
        lock.readLock { result = self.array.contains(element) }
        return result
    }
}

// MARK: - operators overloading
public extension SafeArray {

    static func +=(left: inout SafeArray, right: Element) {
        left.append(right)
    }

    static func +=(left: inout SafeArray, right: [Element]) {
        left.append(right)
    }
}



