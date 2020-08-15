//
//  UIScreen+Extensions.swift
//  GDExtension
//
//  Created by Objc on 2019/8/14.
//

import UIKit


/// This extesion adds some useful functions to UIScreen.
public extension GDReference where Base: UIScreen {
    // MARK: - Variables
    
    /// Get the screen width.
    static var screenWidth: CGFloat {
        return UIScreen.gd.fixedScreenSize().width
    }
    
    /// Get the screen height.
    static var screenHeight: CGFloat {
        return UIScreen.gd.fixedScreenSize().height
    }
    
    /// Get the maximum screen length.
    static var maxScreenLength: CGFloat {
        return max(screenWidth, screenHeight)
    }
    /// Get the minimum screen length.
    static var minScreenLength: CGFloat {
        return min(screenWidth, screenHeight)
    }
    
    static func fixedScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// Returns the screen scale, based on the device.
    ///
    /// - Returns: Returns the screen scale, based on the device.
    static func screenScale() -> CGFloat {
        #if canImport(CoreImage)
        return UIScreen.main.scale
        #elseif canImport(WatchKit)
        return WKInterfaceDevice.current().screenScale
        #endif
    }
}

