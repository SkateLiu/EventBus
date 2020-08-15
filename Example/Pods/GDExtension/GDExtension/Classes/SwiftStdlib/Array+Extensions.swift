//
//  Array+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

// MARK: - Methods
public extension Array {

    /// GDExtension: Insert an element at the beginning of array.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    mutating func insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// GDExtension: Safely swap values at given index positions.
    ///
    ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }

    /// GDExtension: Separates array into 2 arrays based on a given predicate.
    ///
    ///     [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 } -> ( [0, 2, 4], [1, 3, 5] )
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: Two arrays, the first containing the elements for which the specified condition evaluates to true, the second containing the rest.
    func divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        //Inspired by: http://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-partition
        var matching = [Element]()
        var nonMatching = [Element]()
        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    /// GDExtension: Returns a sorted array based on an optional keypath.
    ///
    /// - Parameter path: Key path to sort. The key path type must be Comparable.
    /// - Parameter ascending: If order must be ascending.
    /// - Returns: Sorted array based on keyPath.
    ///         class Person {
    ///             var name:String?
    ///             var age:Int?
    ///             init(name:String?,age:Int?) {
    ///               self.name = name
    ///               self.age = age
    ///           }
    ///      }
    ///                   var array = [Person(name: "Objc", age: 18),Person(name: "CaloudLi", age: 80),Person(name:   "lizb", age: 10)]
    ///
    ///     array.sort(by: \.age, ascending: true)
    ///     var array = [Person(name:   "lizb", age: 10),Person(name: "Objc", age: 18),Person(name: "CaloudLi", age: 80)]
    ///
    ///
    func sorted<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        return sorted(by: { (lhs, rhs) -> Bool in
            guard let lhsValue = lhs[keyPath: path], let rhsValue = rhs[keyPath: path] else { return false }
            return ascending ? (lhsValue < rhsValue) : (lhsValue > rhsValue)
        })
    }

    /// GDExtension: Returns a sorted array based on a keypath.
    ///
    /// - Parameter path: Key path to sort. The key path type must be Comparable.
    /// - Parameter ascending: If order must be ascending.
    /// - Returns: Sorted array based on keyPath.
    func sorted<T: Comparable>(by path: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        return sorted(by: { (lhs, rhs) -> Bool in
            return ascending ? (lhs[keyPath: path] < rhs[keyPath: path]) : (lhs[keyPath: path] > rhs[keyPath: path])
        })
    }

    /// GDExtension: Sort the array based on an optional keypath.
    ///
    /// - Parameters:
    ///   - path: Key path to sort, must be Comparable.
    ///   - ascending: whether order is ascending or not.
    /// - Returns: self after sorting.
    @discardableResult
    mutating func sort<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        self = sorted(by: path, ascending: ascending)
        return self
    }

    /// GDExtension: Sort the array based on a keypath.
    ///
    /// - Parameters:
    ///   - path: Key path to sort, must be Comparable.
    ///   - ascending: whether order is ascending or not.
    /// - Returns: self after sorting.
    @discardableResult
    mutating func sort<T: Comparable>(by path: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        self = sorted(by: path, ascending: ascending)
        return self
    }
    
    /// json
    func toJson() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

}

// MARK: - Methods (Equatable)
public extension Array where Element: Equatable {

    /// GDExtension: Remove all instances of an item from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"].removeAll("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: item to remove.
    /// - Returns: self after removing all instances of item.
    @discardableResult
    mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    /// GDExtension: Remove all instances contained in items parameter from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
    ///        ["h", "e", "l", "l", "o"].removeAll(["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter items: items to remove.
    /// - Returns: self after removing all instances of all items in given array.
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    /// GDExtension: Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns: Return array with all duplicate elements removed.
    @discardableResult
    mutating func removeDuplicates() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }

    /// GDExtension: Return array with all duplicate elements removed.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].withoutDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    func withoutDuplicates() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

}

extension Array where Element: Equatable {
    ///GDExtension Union of self and the input arrays.
    public func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }
    /// GDExtension: Checks if the main array contains the parameter array
    public func contains(_ array: [Element]) -> Bool {
        return array.testAll { self.index(of: $0) ?? -1 >= 0 }
    }
    
    /// GDExtension: Checks if self contains a list of items.
    public func contains(_ elements: Element...) -> Bool {
        return elements.testAll { self.index(of: $0) ?? -1 >= 0 }
    }
    
    /// GDExtension: Returns the indexes of the object
    public func indexes(of element: Element) -> [Int] {
        #if swift(>=4.1)
        return enumerated().compactMap { ($0.element == element) ? $0.offset : nil }
        #else
        return enumerated().flatMap { ($0.element == element) ? $0.offset : nil }
        #endif
    }
    
    /// GDExtension: Returns the last index of the object
    public func lastIndex(of element: Element) -> Int? {
        return indexes(of: element).last
    }
    /// GDExtension: Checks if test returns true for all the elements in self
    public func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return !contains { !body($0) }
    }
    
    public func indexOfEnd(offset: Int) -> Element? {
        if self.count > 0 {
            return self[safe:self.index(before: self.count - offset)]
        }
        return nil
    }
}
public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (lhs?, rhs?):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}
