//
//  RandomAccessCollection+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

public extension RandomAccessCollection where Element: Equatable {

    /// GDExtension: All indices of specified item.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].indices(of 2) -> [1, 2, 5]
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].indices(of 2.3) -> [1]
    ///        ["h", "e", "l", "l", "o"].indices(of "l") -> [2, 3]
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indices of the given item.
    func indices(of item: Element) -> [Index] {
        var indices: [Index] = []
        var idx = startIndex
        while idx < endIndex {
            if self[idx] == item {
                indices.append(idx)
            }
            formIndex(after: &idx)
        }
        return indices
    }

}
