//
//  UIImage+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit)

import CoreGraphics
import Foundation
import UIKit
#endif
#if canImport(CoreImage)
import Accelerate
import CoreImage
#elseif canImport(WatchKit)
import WatchKit
#endif

// MARK: - Methods for GDReference
public extension GDReference where Base: UIImage {

    /// GDExtension: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= base.size.width && rect.size.height <= base.size.height else { return base }
        guard let image: CGImage = base.cgImage?.cropping(to: rect) else { return base }
        return UIImage(cgImage: image)
    }

    /// GDExtension: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// GDExtension: UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// GDExtension: Creates a copy of the receiver rotated by the given angle.
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)

        let destRect = CGRect(origin: .zero, size: base.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        base.draw(in: CGRect(origin: CGPoint(x: -base.size.width / 2,
                                        y: -base.size.height / 2),
                        size: base.size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// GDExtension: Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: base.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        base.draw(in: CGRect(origin: CGPoint(x: -base.size.width / 2,
                                        y: -base.size.height / 2),
                        size: base.size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// GDExtension: UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return base }

        context.translateBy(x: 0, y: base.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        guard let mask = base.cgImage else { return base }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// GDExtension: UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: base.size.width, height: base.size.height)
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        base.draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// GDExtension: UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func cornersRounded(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(base.size.width, base.size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)

        let rect = CGRect(origin: .zero, size: base.size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        base.draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Create a CGSize with a given string (100x100).
    ///
    /// - Parameter sizeString: String with the size.
    /// - Returns: Returns the created CGSize.
    static func size(sizeString: String) -> CGSize {
        let array = sizeString.components(separatedBy: "x")
        guard array.count >= 2 else {
            return CGSize.zero
        }
        
        return CGSize(width: CGFloat(array[0].floatValue), height: CGFloat(array[1].floatValue))
    }
    
    /// Apply the given Blend Mode.
    ///
    /// - Parameters:
    ///   - image: Image to be added to blend.
    ///   - blendMode: Blend Mode.
    /// - Returns: Returns the image.
    func blend(image: UIImage, blendMode: CGBlendMode) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        
        UIGraphicsBeginImageContextWithOptions(base.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return base
        }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        
        base.draw(in: rect, blendMode: .normal, alpha: 1)
        image.draw(in: rect, blendMode: blendMode, alpha: 1)
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /// Create an image from a given rect of
    ///
    /// - Parameter rect:  Rect to take the image.
    /// - Returns: Returns the image from a given rect.
    func crop(in rect: CGRect) -> UIImage {
        guard let imageRef = base.cgImage?.cropping(to: CGRect(x: rect.origin.x * base.scale, y: rect.origin.y * base.scale, width: rect.size.width * base.scale, height: rect.size.height * base.scale)) else {
            return base
        }
        
        let subImage = UIImage(cgImage: imageRef, scale: base.scale, orientation: base.imageOrientation)
        
        return subImage
    }
    
    /// Scale the image to the minimum given size.
    ///
    /// - Parameter targetSize: The size to scale to.
    /// - Returns: Returns the scaled image.
    func scaleProportionally(toMinimumSize targetSize: CGSize) -> UIImage {
        let sourceImage: UIImage = base
        let newTargetSize: CGSize = targetSize
        
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        
        let targetWidth: CGFloat = newTargetSize.width
        let targetHeight: CGFloat = newTargetSize.height
        
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if imageSize.equalTo(newTargetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            
            scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor
            
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(newTargetSize, false, UIScreen.gd.screenScale())
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Scale the image to the maxinum given size.
    ///
    /// - Parameter targetSize: The site to scale to.
    /// - Returns: Returns the scaled image.
    func scaleProportionally(toMaximumSize targetSize: CGSize) -> UIImage {
        let newTargetSize: CGSize = targetSize
        
        if base.size.width > newTargetSize.width || newTargetSize.width == newTargetSize.height, base.size.width > base.size.height {
            let factor: CGFloat = (newTargetSize.width * 100) / base.size.width
            let newWidth: CGFloat = (base.size.width * factor) / 100
            let newHeight: CGFloat = (base.size.height * factor) / 100
            
            let newSize = CGSize(width: newWidth, height: newHeight)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.gd.screenScale())
            base.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        } else if base.size.height > newTargetSize.height || newTargetSize.width == newTargetSize.height, base.size.width < base.size.height {
            let factor: CGFloat = (newTargetSize.width * 100) / base.size.height
            let newWidth: CGFloat = (base.size.width * factor) / 100
            let newHeight: CGFloat = (base.size.height * factor) / 100
            
            let newSize = CGSize(width: newWidth, height: newHeight)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.gd.screenScale())
            base.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        } else if base.size.height > newTargetSize.height || base.size.width > newTargetSize.width, base.size.width == base.size.height {
            let factor: CGFloat = (newTargetSize.height * 100) / base.size.height
            let newDimension: CGFloat = (base.size.height * factor) / 100
            
            let newSize = CGSize(width: newDimension, height: newDimension)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.gd.screenScale())
            base.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        } else {
            let newSize = CGSize(width: base.size.width, height: base.size.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.gd.screenScale())
            base.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }
        
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Scale the image proportionally to the given size.
    ///
    /// - Parameter targetSize: The site to scale to.
    /// - Returns: Returns the scaled image.
    func scaleProportionally(toSize targetSize: CGSize) -> UIImage {
        let sourceImage: UIImage = base
        let newTargetSize: CGSize = targetSize
        
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        
        let targetWidth: CGFloat = newTargetSize.width
        let targetHeight: CGFloat = newTargetSize.height
        
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if imageSize.equalTo(newTargetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            
            if widthFactor < heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor < heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if widthFactor > heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(newTargetSize, false, UIScreen.gd.screenScale())
        
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Scele the image to the given size.
    ///
    /// - Parameter targetSize: The site to scale to.
    /// - Returns: Returns the scaled image.
    func scale(toSize targetSize: CGSize) -> UIImage {
        let sourceImage: UIImage = base
        
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        
        let scaledWidth: CGFloat = targetWidth
        let scaledHeight: CGFloat = targetHeight
        
        let thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.gd.screenScale())
        
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addBorder(width: CGFloat,color: UIColor) -> UIImage {
        let sourceImage: UIImage = base
        
        let targetWidth: CGFloat = base.size.width
        let targetHeight: CGFloat = base.size.height
        
        let scaledWidth: CGFloat = targetWidth+2*width
        let scaledHeight: CGFloat = targetHeight+2*width
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: scaledWidth, height: scaledHeight), false, UIScreen.gd.screenScale())
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: CGSize(width: scaledWidth, height: scaledHeight)))
        sourceImage.draw(in: CGRect(x: width, y: width, width: targetWidth, height: targetHeight))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Scele the image to the given length.   use kB
    ///
    /// - Parameter targetLength: The lenght to scale to.
    /// - Returns: Returns the scaled image.
    func scaleImageToFitLength(toLength targetLength: Int) -> Data? {
        let sourceImage: UIImage = base
        let composs = targetLength*1024
        
        var compression:CGFloat = 1
        
        guard var data = sourceImage.jpegData(compressionQuality: compression) else { return nil }
        
        if data.count <= composs {
            
            return  data
            
        }
        
        var max:CGFloat = 1,min:CGFloat = 0.8//最小0.8
        
        for _ in 0..<6 {//最多压缩6次
            
            compression = (max+min)/2
            
            if let tmpdata = sourceImage.jpegData(compressionQuality: compression) {
                
                data = tmpdata
                
            } else {
                
                return nil
                
            }
            
            if data.count <= composs {
                
                return data
                
            } else {
                
                max = compression
                
            }
            
        }
        
        
        
        //压缩分辨率
        
        guard var resultImage = UIImage(data: data) else { return nil }
        
        var lastDataCount:Int = 0
        
        while data.count > composs && data.count != lastDataCount {
            
            lastDataCount = data.count
            
            let ratio = CGFloat(composs)/CGFloat(data.count)
            
            let size = CGSize(width: resultImage.size.width*sqrt(ratio), height: resultImage.size.height*sqrt(ratio))
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(Int(size.width)), height: CGFloat(Int(size.height))), true, 1)//防止黑边
            
            resultImage.draw(in: CGRect(origin: .zero, size: size))//比转成Int清晰
            
            if let tmp = UIGraphicsGetImageFromCurrentImageContext() {
                
                resultImage = tmp
                
                UIGraphicsEndImageContext()
                
            } else {
                
                UIGraphicsEndImageContext()
                
                return  data
                
            }
            
            if let tmpdata = resultImage.jpegData(compressionQuality: compression) {
                
                data = tmpdata
                
            } else {
                
                return nil
                
            }
            
        }
        
        return  data
    }
    
    /// Flip the image horizontally, like a mirror.
    ///
    /// Example: Image -> egamI.
    ///
    /// - Returns: Returns the flipped image.
    func flipHorizontally() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
        guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = base.cgImage else {
            UIGraphicsEndImageContext()
            return base
        }
        
        context.translateBy(x: 0, y: base.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.translateBy(x: base.size.width, y: 0)
        context.scaleBy(x: -1.0, y: 1.0)
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Flip the image vertically.
    ///
    /// Example: Image -> Iɯɐƃǝ.
    ///
    /// - Returns: Returns the flipped image.
    func flipVertically() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
        guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = base.cgImage else {
            UIGraphicsEndImageContext()
            return base
        }
        
        context.translateBy(x: 0, y: 0)
        context.scaleBy(x: 1.0, y: 1.0)
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /// 修复图片旋转
    func fixOrientation() -> UIImage {
        if base.imageOrientation == .up {
            return base
        }
        
        var transform = CGAffineTransform.identity
        
        switch base.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: base.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: base.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: base.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(base.size.width), height: Int(base.size.height), bitsPerComponent: base.cgImage!.bitsPerComponent, bytesPerRow: 0, space: base.cgImage!.colorSpace!, bitmapInfo: base.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(base.size.height), height: CGFloat(base.size.width)))
            break
            
        default:
            ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(base.size.width), height: CGFloat(base.size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
    
    
    /// Check if the image has alpha.
    ///
    /// - Returns: Returns true if has alpha, otherwise false.
    func hasAlpha() -> Bool {
        guard let cgImage = base.cgImage else {
            return false
        }
        
        let alpha: CGImageAlphaInfo = cgImage.alphaInfo
        return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
    }
    
    /// Remove the alpha of the image.
    ///
    /// - Returns: Returns the image without alpha.
    func removeAlpha() -> UIImage {
        guard hasAlpha(), let cgImage = base.cgImage else {
            return base
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let mainViewContentContext = CGContext(data: nil, width: Int(base.size.width), height: Int(base.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return base
        }
        
        mainViewContentContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        guard let mainViewContentBitmapContext = mainViewContentContext.makeImage() else {
            return base
        }
        
        let newImage = UIImage(cgImage: mainViewContentBitmapContext)
        
        return newImage
    }
    
    /// Fill the alpha with the given color.
    ///
    /// Default is white.
    ///
    /// - Parameter color: Color to fill.
    /// - Returns: Returns the filled image.
    func fillAlpha(color: UIColor = UIColor.white) -> UIImage {
        let imageRect = CGRect(origin: CGPoint.zero, size: base.size)
        
        let cgColor = color.cgColor
        
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        context.setFillColor(cgColor)
        context.fill(imageRect)
        base.draw(in: imageRect)
        
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Check if the image is in grayscale.
    ///
    /// - Returns: Returns true if is in grayscale, otherwise false.
    func isGrayscale() -> Bool {
        guard let model: CGColorSpaceModel = base.cgImage?.colorSpace?.model else {
            return false
        }
        
        return model == CGColorSpaceModel.monochrome
    }
    
    /// Transform the image to grayscale.
    ///
    /// - Returns: Returns the transformed image.
    func toGrayscale() -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: base.size.width, height: base.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        guard let cgImage = base.cgImage, let context = CGContext(data: nil, width: Int(rect.width), height: Int(rect.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0) else {
            return base
        }
        
        context.draw(cgImage, in: rect)
        
        guard let grayscale: CGImage = context.makeImage() else {
            return base
        }
        
        let newImage = UIImage(cgImage: grayscale)
        
        return newImage
    }
    
    /// Transform the image to black and white.
    ///
    /// - Returns: Returns the transformed image.
    func toBlackAndWhite() -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: base.size.width, height: base.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        guard let cgImage = base.cgImage, let context = CGContext(data: nil, width: Int(rect.width), height: Int(rect.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0) else {
            return base
        }
        
        context.interpolationQuality = .high
        context.setShouldAntialias(false)
        context.draw(cgImage, in: rect)
        
        guard let bwImage = context.makeImage() else {
            return base
        }
        
        let newImage = UIImage(cgImage: bwImage)
        
        return newImage
    }
    
    /// Invert the color of the image.
    ///
    /// - Returns: Returns the transformed image.
    func invertColors() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
        UIGraphicsGetCurrentContext()?.setBlendMode(.copy)
        base.draw(in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        UIGraphicsGetCurrentContext()?.setBlendMode(.difference)
        UIGraphicsGetCurrentContext()?.setFillColor(UIColor.white.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return base
        }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Rotate the image to the given radians.
    ///
    /// - Parameter radians: Radians to rotate to
    /// - Returns: Returns the rotated image.
    func rotate(radians: Double) -> UIImage {
        return rotate(degrees: radiansToDegrees(radians))
    }
    
    /// Rotate the image to the given degrees.
    ///
    /// - Parameter degrees: Degrees to rotate to.
    /// - Returns: Returns the rotated image.
    func rotate(degrees: Double) -> UIImage {
        let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        let transformation = CGAffineTransform(rotationAngle: CGFloat(degreesToRadians(degrees)))
        rotatedViewBox.transform = transformation
        let rotatedSize = CGSize(width: Int(rotatedViewBox.frame.size.width), height: Int(rotatedViewBox.frame.size.height))
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, UIScreen.gd.screenScale())
        guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = base.cgImage else {
            UIGraphicsEndImageContext()
            return base
        }
        
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        context.rotate(by: CGFloat(degreesToRadians(degrees)))
        
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: CGRect(x: -base.size.width / 2, y: -base.size.height / 2, width: base.size.width, height: base.size.height))
        
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Apply a filter to the image.
    /// Full list of CIFilters [here](https://developer.apple.com/library/prerelease/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/).
    ///
    /// - Parameters:
    ///   - name: Filter name.
    ///   - parameters: Keys and values of the filter. A key example is kCIInputCenterKey.
    /// - Returns: Returns the transformed image.
    func filter(name: String, parameters: [String: Any] = [:]) -> UIImage {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: name), let ciImage = CIImage(image: base) else {
            return base
        }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        for (key, value) in parameters {
            filter.setValue(value, forKey: key)
        }
        
        guard let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return base
        }
        
        let newImage = UIImage(cgImage: cgImage, scale: UIScreen.gd.screenScale(), orientation: base.imageOrientation)
        
        return newImage.gd.scale(toSize: base.size)
    }
    
    /// Apply the bloom effect to the image.
    ///
    /// - Parameters:
    ///   - radius: Radius of the bloom.
    ///   - intensity: Intensity of the bloom.
    /// - Returns: Returns the transformed image.
    func bloom(radius: Float, intensity: Float) -> UIImage {
        return filter(name: "CIBloom", parameters: [kCIInputRadiusKey: radius, kCIInputIntensityKey: intensity])
    }
    
    /// Apply the bump distortion effect to the image.
    ///
    /// - Parameters:
    ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
    ///   - radius: Radius of the effect.
    ///   - scale: Scale of the effect.
    /// - Returns: Returns the transformed image.
    func bumpDistortion(center: CIVector, radius: Float, scale: Float) -> UIImage {
        return filter(name: "CIBumpDistortion", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputScaleKey: scale])
    }
    
    /// Apply the bump distortion linear effect to the image.
    ///
    /// - Parameters:
    ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
    ///   - radius: Radius of the effect.
    ///   - scale: Scale of the effect.
    ///   - angle: Angle of the effect in radians.
    /// - Returns: Returns the transformed image.
    func bumpDistortionLinear(center: CIVector, radius: Float, scale: Float, angle: Float) -> UIImage {
        return filter(name: "CIBumpDistortionLinear", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputScaleKey: scale, kCIInputAngleKey: angle])
    }
    
    /// Apply the circular splash distortion effect to the image
    ///
    /// - Parameters:
    ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
    ///   - radius: Radius of the effect.
    /// - Returns: Returns the transformed image.
    func circleSplashDistortion(center: CIVector, radius: Float) -> UIImage {
        return filter(name: "CICircleSplashDistortion", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius])
    }
    
    /// Apply the circular wrap effect to the image.
    ///
    /// - Parameters:
    ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
    ///   - radius: Radius of the effect.
    ///   - angle: Angle of the effect in radians.
    /// - Returns: Returns the transformed image.
    func circularWrap(center: CIVector, radius: Float, angle: Float) -> UIImage {
        return filter(name: "CICircularWrap", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputAngleKey: angle])
    }
    
    /// Apply the CMY halftone effect to the image.
    ///
    /// - Parameters:
    ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
    ///   - width: Width value.
    ///   - angle: Angle of the effect in radians.
    ///   - sharpness: Sharpness Value.
    ///   - gcr: GCR value.
    ///   - ucr: UCR value
    /// - Returns: Returns the transformed image.
    func cmykHalftone(center: CIVector, width: Float, angle: Float, sharpness: Float, gcr: Float, ucr: Float) -> UIImage { // swiftlint:disable:this function_parameter_count
        return filter(name: "CICMYKHalftone", parameters: [kCIInputCenterKey: center, kCIInputWidthKey: width, kCIInputSharpnessKey: sharpness, kCIInputAngleKey: angle, "inputGCR": gcr, "inputUCR": ucr])
    }
    
    /// Apply the sepia filter to the image.
    ///
    /// - Parameter intensity: Intensity of the filter.
    /// - Returns: Returns the transformed image.
    func sepiaTone(intensity: Float) -> UIImage {
        return filter(name: "CISepiaTone", parameters: [kCIInputIntensityKey: intensity])
    }
    
    /// Apply the blur effect to the image.
    ///
    /// - Parameters:
    ///   - blurRadius: Blur radius.
    ///   - saturation: Saturation delta factor, leave it default (1.8) if you don't what is.
    ///   - tintColor: Blur tint color, default is nil.
    ///   - maskImage: Apply a mask image, leave it default (nil) if you don't want to mask.
    /// - Returns: Return the transformed image.
    func blur(radius blurRadius: CGFloat, saturation: CGFloat = 1.8, tintColor: UIColor? = nil, maskImage: UIImage? = nil) -> UIImage {
        guard base.size.width > 1 && base.size.height > 1, let selfCGImage = base.cgImage else {
            return base
        }
        
        let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: base.size)
        var effectImage = base
        
        let hasBlur = Float(blurRadius) > Float.ulpOfOne
        let saturationABS = abs(saturation - 1)
        let saturationABSFloat = Float(saturationABS)
        let hasSaturationChange = saturationABSFloat > Float.ulpOfOne
        
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
            guard let effectInContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return base
            }
            effectInContext.scaleBy(x: 1, y: -1)
            effectInContext.translateBy(x: 0, y: -base.size.height)
            effectInContext.draw(selfCGImage, in: imageRect)
            var effectInBuffer = vImage_Buffer(data: effectInContext.data, height: UInt(effectInContext.height), width: UInt(effectInContext.width), rowBytes: effectInContext.bytesPerRow)
            
            UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
            guard let effectOutContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return base
            }
            var effectOutBuffer = vImage_Buffer(data: effectOutContext.data, height: UInt(effectOutContext.height), width: UInt(effectOutContext.width), rowBytes: effectOutContext.bytesPerRow)
            
            if hasBlur {
                var inputRadius = blurRadius * UIScreen.gd.screenScale()
                let sqrt2PI = CGFloat(sqrt(2 * Double.pi))
                inputRadius = inputRadius * 3.0 * sqrt2PI / 4 + 0.5
                var radius = UInt32(floor(inputRadius))
                if radius % 2 != 1 {
                    radius += 1
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            if hasSaturationChange {
                let floatingPointSaturationMatrix = [
                    0.0722 + 0.9278 * saturation, 0.0722 - 0.0722 * saturation, 0.0722 - 0.0722 * saturation, 0,
                    0.7152 - 0.7152 * saturation, 0.7152 + 0.2848 * saturation, 0.7152 - 0.7152 * saturation, 0,
                    0.2126 - 0.2126 * saturation, 0.2126 - 0.2126 * saturation, 0.2126 + 0.7873 * saturation, 0,
                    0, 0, 0, 1
                ]
                
                let divisor: CGFloat = 256
                let saturationMatrix = floatingPointSaturationMatrix.map {
                    return Int16(round($0 * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            guard let imageContext = UIGraphicsGetImageFromCurrentImageContext() as? Base else {
                return base
            }
            
            effectImage = imageContext
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.gd.screenScale())
        guard let outputContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        outputContext.scaleBy(x: 1, y: -1)
        outputContext.translateBy(x: 0, y: -base.size.height)
        
        outputContext.draw(selfCGImage, in: imageRect)
        
        if hasBlur {
            outputContext.saveGState()
            
            if let maskImage = maskImage, let maskCGImage = maskImage.cgImage {
                outputContext.clip(to: imageRect, mask: maskCGImage)
            } else if let effectCGImage = effectImage.cgImage {
                outputContext.draw(effectCGImage, in: imageRect)
            }
            
            outputContext.restoreGState()
        }
        
        if let tintColor = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(tintColor.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return base
        }
        
        UIGraphicsEndImageContext()
        
        return outputImage
    }

}

// MARK: - Initializers
public extension UIImage {

    /// GDExtension: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }

}

/// This extesion adds some useful functions to UIImage.
public extension UIImage {
    // MARK: - Functions
    
    /// Create a dummy image.
    ///
    /// - Parameter dummy: This parameter must contain: "100x100", "100x100.#FFFFFF" or "100x100.blue" (if it is a color defined in UIColor class) if you want to define a color. Default color is lightGray.
    convenience init?(dummyImage dummy: String) {
        var size = CGSize.zero, color = UIColor.lightGray
        
        let array = dummy.components(separatedBy: ".")
        if !array.isEmpty {
            let sizeString: String = array[0]
            
            if array.count > 1 {
                color = UIColor.color(string: array[1])
            }
            
            size = UIImage.gd.size(sizeString: sizeString)
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.gd.screenScale())
        
        let rect = CGRect(origin: .zero, size: size)
        
        color.setFill()
        UIRectFill(rect)
        
        let widthInt = Int(size.width)
        let heightInt = Int(size.height)
        let sizeString = "\(widthInt) x \(heightInt)"
        guard let paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {
            return nil
        }
        
        let style = paragraphStyle
        style.alignment = .center
        style.minimumLineHeight = size.height / 2
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        sizeString.draw(in: rect, withAttributes: attributes)
        
        if let result = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = result.cgImage {
            UIGraphicsEndImageContext()
            self.init(cgImage: cgImage, scale: UIScreen.gd.screenScale(), orientation: .up)
        } else {
            UIGraphicsEndImageContext()
            self.init(color: color)
        }
    }
    
    /// Create a dummy image.
    ///
    /// - Parameters:
    ///   - width: Width of dummy image.
    ///   - height: Height of dummy image.
    ///   - color: Color of dummy image. Can be HEX or color like "blue". Default color is lightGray.
    convenience init?(width: CGFloat, height: CGFloat, color: String = "lightGray") {
        self.init(dummyImage: "\(Int(width))x\(Int(height)).\(color)")
    }
    
    /// Create a dummy image.
    ///
    /// - Parameters
    ///   - size: Size of dummy image.
    ///   - color: Color of dummy image. Can be HEX or color like "blue". Default color is lightGray.
    convenience init?(size: CGSize, color: String = "lightGray") {
        self.init(width: size.height, height: size.width, color: color)
    }
    
    /// Create an image from a given text.
    ///
    /// - Parameters:
    ///   - text: Text.
    ///   - font: Text font name.
    ///   - fontSize: Text font size.
    ///   - imageSize: Image size.
    convenience init?(text: String, font: FontName, fontSize: CGFloat, imageSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.gd.screenScale())
        
        text.draw(at: CGPoint(x: 0.0, y: 0.0), withAttributes: [NSAttributedString.Key.font: UIFont(fontName: font, size: fontSize) as Any])
        
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: cgImage, scale: UIScreen.gd.screenScale(), orientation: .up)
    }
    
    /// Create an image with a background color and with a text with a mask.
    ///
    /// - Parameters:
    ///   - maskedText: Text to mask.
    ///   - font: Text font name.
    ///   - fontSize: Text font size.
    ///   - imageSize: Image size.
    ///   - backgroundColor: Image background color.
    convenience init?(maskedText: String, font: FontName, fontSize: CGFloat, imageSize: CGSize, backgroundColor: UIColor) {
        guard let fontName = UIFont(fontName: font, size: fontSize) else {
            return nil
        }
        
        let textAttributes = [NSAttributedString.Key.font: fontName]
        let textSize = maskedText.size(withAttributes: textAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false,UIScreen.gd.screenScale())
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(backgroundColor.cgColor)
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
        context.addPath(path.cgPath)
        context.fillPath()
        
        context.setBlendMode(.destinationOut)
        
        let center = CGPoint(x: imageSize.width / 2 - textSize.width / 2, y: imageSize.height / 2 - textSize.height / 2)
        
        maskedText.draw(at: center, withAttributes: textAttributes)
        
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: cgImage, scale: UIScreen.gd.screenScale(), orientation: .up)
    }
    
    /// Create an image from a given color.
    ///
    /// - Parameter color: Color value.
    convenience init?(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1 * UIScreen.gd.screenScale(), height: 1 * UIScreen.gd.screenScale())
        
        UIGraphicsBeginImageContext(rect.size)
        
        color.setFill()
        UIRectFill(rect)
        
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: cgImage, scale: UIScreen.gd.screenScale(), orientation: .up)
    }
    
    /// Create an image from a base64 String.
    ///
    /// - Parameter base64: Base64 String.
    convenience init?(base64: String) {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        self.init(data: data)
    }
    #if canImport(CoreImage)
    /// Creates an image from an UIView.
    ///
    /// - Parameter view: UIView.
    convenience init?(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }

    #endif
}
