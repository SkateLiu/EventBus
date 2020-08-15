//
//  UISlider+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && os(iOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base: UISlider {

    /// GDExtension: Set slide bar value with completion handler.
    ///
    /// - Parameters:
    ///   - value: slider value.
    ///   - animated: set true to animate value change (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: an optional completion handler to run after value is changed (default is nil)
    func setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.base.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            base.setValue(value, animated: false)
            completion?()
        }
    }

}

#endif
