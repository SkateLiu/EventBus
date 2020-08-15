//
//  UISegmentedControl+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties
public extension GDReference where Base: UISegmentedControl {

    /// GDExtension: Segments titles.
    var segmentTitles: [String] {
        get {
            let range = 0..<base.numberOfSegments
            return range.compactMap { base.titleForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                base.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }

    /// GDExtension: Segments images.
    var segmentImages: [UIImage] {
        get {
            let range = 0..<base.numberOfSegments
            return range.compactMap { base.imageForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                base.insertSegment(with: image, at: index, animated: false)
            }
        }
    }

}

#endif
