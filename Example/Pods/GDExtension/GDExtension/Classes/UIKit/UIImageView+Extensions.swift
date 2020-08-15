//
//  UIImageView+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import Foundation
import QuartzCore
import UIKit

// MARK: - Methods
public extension GDReference where Base: UIImageView {

    
    /// GDExtension: Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = base.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        base.addSubview(blurEffectView)
        base.clipsToBounds = true
    }

    /// GDExtension: Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = base
        imgView.gd.blur(withStyle: style)
        return imgView
    }
    
    /// Create a drop shadow effect.
    ///
    /// - Parameters:
    ///   - color: Shadow color.
    ///   - radius: Shadow radius.
    ///   - offset: Shadow offset.
    ///   - opacity: Shadow opacity.
    func shadow(color: UIColor, radius: CGFloat, offset: CGSize, opacity: Float) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
        base.layer.shadowOffset = offset
        base.layer.shadowOpacity = opacity
        base.clipsToBounds = false
    }
    
    /// Mask the current UIImageView with an UIImage.
    ///
    /// - Parameter image: The mask UIImage.
    func mask(image: UIImage) {
        let mask = CALayer()
        mask.contents = image.cgImage
        mask.frame = CGRect(x: 0, y: 0, width: base.frame.size.width, height: base.frame.size.height)
        base.layer.mask = mask
        base.layer.masksToBounds = false
    }

}
/// This extesion adds some useful functions to UIImageView.
public extension UIImageView {
    // MARK: - Functions
    
    /// Create an UIImageView with the given image and frame
    ///
    /// - Parameters:
    ///   - frame: UIImageView frame.
    ///   - image: UIImageView image.
    /// - Returns: Returns the created UIImageView.
    convenience init(image: UIImage) {
        self.init(frame: CGRect.zero)
        self.image = image
    }
    
    /// Create an UIImageView with the given image, size and center.
    ///
    /// - Parameters:
    ///   - image: UIImageView image.
    ///   - size: UIImageView size.
    ///   - center: UIImageView center.
    /// - Returns: Returns the created UIImageView.
    convenience init(image: UIImage, size: CGSize, center: CGPoint) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.image = image
        self.center = center
    }
    
    /// Create an UIImageView with the given image and center.
    ///
    /// - Parameters:
    ///   - image: UIImageView image.
    ///   - center: UIImageView center.
    /// - Returns: Returns the created UIImageView.
    convenience init(image: UIImage, center: CGPoint) {
        self.init(image: image)
        self.center = center
    }
    
    /// Create an UIImageView with the given image and center.
    ///
    /// - Parameters:
    ///   - imageTemplate: UIImage template.
    ///   - tintColor: Template color.
    /// - Returns: Returns the created UIImageView.
    convenience init(imageTemplate: UIImage, tintColor: UIColor) {
        var newImageTemplate = imageTemplate
        self.init(image: newImageTemplate)
        newImageTemplate = newImageTemplate.withRenderingMode(.alwaysTemplate)
        self.tintColor = tintColor
    }
    
}

#endif
