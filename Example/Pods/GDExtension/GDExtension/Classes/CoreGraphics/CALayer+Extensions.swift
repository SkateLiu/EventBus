//
//  CALayer+Extensions.swift
//  GDExtension
//
//  Created by Objc on 2019/8/15.
//

import UIKit

// MARK: - Properties
public extension CALayer {
    /// GDExtension: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            w = newValue.width
            h = newValue.height
        }
    }
    
    /// GDExtension: Height of view.
    var h: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// GDExtension: Width of view.
    var w: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// GDExtension: x origin of view.
    // swiftlint:disable:next identifier_name
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// GDExtension: y origin of view.
    // swiftlint:disable:next identifier_name
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// GDExtension: getter and setter for the x coordinate of leftmost edge of the view.
    var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    /// GDExtension: getter and setter for the x coordinate of the rightmost edge of the view.
    var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }
    
    /// GDExtension: getter and setter for the y coordinate for the topmost edge of the view.
    var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }
    
    /// GDExtension: getter and setter for the y coordinate of the bottom most edge of the view.
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }
    
    /// GDExtension: getter and setter the frame's origin point of the view.
    var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
}
