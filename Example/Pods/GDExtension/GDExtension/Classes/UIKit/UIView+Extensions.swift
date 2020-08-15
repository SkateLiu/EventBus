//
//  UIView+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - enums
public extension GDReference where Base:  UIView {

    /// GDExtension: Shake directions of a view.
    ///
    /// - horizontal: Shake left and right.
    /// - vertical: Shake up and down.
    enum ShakeDirection {
        /// Shake left and right.
        case horizontal

        /// Shake up and down.
        case vertical
    }

    /// GDExtension: Angle units.
    ///
    /// - degrees: degrees.
    /// - radians: radians.
    enum AngleUnit {
        /// degrees.
        case degrees

        /// radians.
        case radians
    }

    /// GDExtension: Shake animations types.
    ///
    /// - linear: linear animation.
    /// - easeIn: easeIn animation.
    /// - easeOut: easeOut animation.
    /// - easeInOut: easeInOut animation.
    enum ShakeAnimationType {
        /// linear animation.
        case linear

        /// easeIn animation.
        case easeIn

        /// easeOut animation.
        case easeOut

        /// easeInOut animation.
        case easeInOut
    }

}

// MARK: - Properties
public extension UIView {
    
    /// GDExtension: Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// GDExtension: Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// GDExtension: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// GDExtension: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// GDExtension: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// GDExtension: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// GDExtension: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

}
public extension GDReference where Base: UIView {
    /// GDExtension: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = base
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// GDExtension: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return base.effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// GDExtension: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// GDExtension: Size of view.
    var size: CGSize {
        get {
            return base.frame.size
        }
        set {
            w = newValue.width
            h = newValue.height
        }
    }
    
    /// GDExtension: Height of view.
    var h: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            base.frame.size.height = newValue
        }
    }
    
    /// GDExtension: Width of view.
    var w: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            base.frame.size.width = newValue
        }
    }
    
    /// GDExtension: x origin of view.
    // swiftlint:disable:next identifier_name
    var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            base.frame.origin.x = newValue
        }
    }
    
    /// GDExtension: y origin of view.
    // swiftlint:disable:next identifier_name
    var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            base.frame.origin.y = newValue
        }
    }
    
    /// GDExtension: getter and setter for the x coordinate of leftmost edge of the view.
    var left: CGFloat {
        get {
            return base.gd.x
        } set(value) {
            base.gd.x = value
        }
    }
    
    /// GDExtension: getter and setter for the x coordinate of the rightmost edge of the view.
    var right: CGFloat {
        get {
            return base.gd.x + base.gd.w
        } set(value) {
            base.gd.x = value - base.gd.w
        }
    }
    
    /// GDExtension: getter and setter for the y coordinate for the topmost edge of the view.
    var top: CGFloat {
        get {
            return base.gd.y
        } set(value) {
            base.gd.y = value
        }
    }
    
    /// GDExtension: getter and setter for the y coordinate of the bottom most edge of the view.
    var bottom: CGFloat {
        get {
            return base.gd.y + base.gd.h
        } set(value) {
            base.gd.y = value - base.gd.h
        }
    }
    
    /// GDExtension: getter and setter the frame's origin point of the view.
    var origin: CGPoint {
        get {
            return base.frame.origin
        } set(value) {
            base.frame = CGRect(origin: value, size: base.frame.size)
        }
    }
    
    /// GDExtension: getter and setter for the X coordinate of the center of a view.
    var centerX: CGFloat {
        get {
            return base.center.x
        } set(value) {
            base.center.x = value
        }
    }
    
    /// GDExtension: getter and setter for the Y coordinate for the center of a view.
    var centerY: CGFloat {
        get {
            return base.center.y
        } set(value) {
            base.center.y = value
        }
    }
}

// MARK: - Methods
public extension GDReference where Base: UIView {

    /// GDExtension: Recursively find the first responder.
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: base)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }
    
    /// GDExtension: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: base.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        base.layer.mask = shape
    }

    /// GDExtension: Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.masksToBounds = false
    }

    /// GDExtension: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { base.addSubview($0) }
    }

    /// GDExtension: Load view from nib.
    ///
    /// - Returns: optional UIView (if applicable).
    class func loadFromNib() -> Base? {
        let className = self.base
        let bundle = Bundle(for: className )
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        return UINib(nibName: name!, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Base
    }

    /// GDExtension: Remove all subviews in view.
    func removeSubviews() {
        base.subviews.forEach({ $0.removeFromSuperview() })
    }

    /// GDExtension: Remove all gesture recognizers from view.
    func removeGestureRecognizers() {
        base.gestureRecognizers?.forEach(base.removeGestureRecognizer)
    }

    /// GDExtension: Attaches gesture recognizers to the view.
    ///
    /// Attaching gesture recognizers to a view defines the scope of the represented
    /// gesture, causing it to receive touches hit-tested to that view and all of its
    /// subviews. The view establishes a strong reference to the gesture recognizers.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be added to the view.
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            base.addGestureRecognizer(recognizer)
        }
    }

    /// GDExtension: Detaches gesture recognizers from the receiving view.
    ///
    /// This method releases gestureRecognizers in addition to detaching them from the view.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be removed from the view.
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            base.removeGestureRecognizer(recognizer)
        }
    }

    /// GDExtension: Search all superviews until a view with the condition is found.
    ///
    /// - Parameter predicate: predicate to evaluate on superviews.
    func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(base.superview) {
            return base.superview
        }
        return base.superview?.gd.ancestorView(where: predicate)
    }

    /// GDExtension: Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: class of the view to search.
    func ancestorView<T: UIView>(withClass name: T.Type) -> T? {
        return ancestorView(where: { $0 is T }) as? T
    }

}

// MARK: - Anchor
public extension GDReference where Base: UIView{
    
    /// GDExtension: Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @available(iOS 9, *)
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // https://videos.letsbuildthatapp.com/
        base.translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(base.topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(base.leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(base.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(base.rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(base.widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(base.heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    /// GDExtension: Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *)
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        base.translatesAutoresizingMaskIntoConstraints = false
        if let anchor = base.superview?.centerXAnchor {
            base.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// GDExtension: Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *)
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        base.translatesAutoresizingMaskIntoConstraints = false
        if let anchor = base.superview?.centerYAnchor {
            base.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// GDExtension: Anchor center X and Y into current view's superview
    @available(iOS 9, *)
    func anchorCenterSuperview() {
        // https://videos.letsbuildthatapp.com/
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}
// MARK: - Animations
private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

public extension GDReference where Base: UIView{
    /// GDExtension: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if base.isHidden {
            base.isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.base.alpha = 1
        }, completion: completion)
    }
    
    /// GDExtension: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if base.isHidden {
            base.isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.base.alpha = 0
        }, completion: completion)
    }
    
    /// GDExtension: Rotate view by angle on relative axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view by.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.base.transform = self.base.transform.rotated(by: angleWithType)
        }, completion: completion)
    }
    
    /// GDExtension: Rotate view to angle on fixed axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view to.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func rotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.base.transform = self.base.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }
    
    /// GDExtension: Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.base.transform = self.base.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            base.transform = base.transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
    
    /// GDExtension: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        base.layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
    
    /// GDExtension
    func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    /// GDExtension
    func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIView.AnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }
    
    /// GDExtension
    func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    /// GDExtension
    func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    /// GDExtension
    func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
    /// GDExtension
    func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
    //GDExtension: Reverse pop, good for button animations
    func reversePop() {
        setScale(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.05, delay: 0, options: .allowUserInteraction, animations: {[weak self] in
            self?.setScale(x: 1, y: 1)
            }, completion: { (_) in })
    }
}

// MARK: Transform Extensions
public extension GDReference where Base: UIView{
    /// GDExtension
    func setRotationX(_ x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.radiansToDegrees, 1.0, 0.0, 0.0)
        base.layer.transform = transform
    }
    
    /// GDExtension
    func setRotationY(_ y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.radiansToDegrees, 0.0, 1.0, 0.0)
        base.layer.transform = transform
    }
    
    /// GDExtension
    func setRotationZ(_ z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.radiansToDegrees, 0.0, 0.0, 1.0)
        base.layer.transform = transform
    }
    
    /// GDExtension
    func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.radiansToDegrees, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.radiansToDegrees, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.radiansToDegrees, 0.0, 0.0, 1.0)
        base.layer.transform = transform
    }
    
    /// GDExtension
    func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        base.layer.transform = transform
    }
}
// MARK: Border
public extension GDReference where Base: UIView{

    /// GDExtension: Set only top border for view
    ///
    /// - Parameters:
    ///   - size: border size
    ///   - color: color for border
    func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: base.frame.width, height: size, color: color)
    }
    
    /// GDExtension: Set only top border for view
    ///
    /// - Parameters:
    ///   - size: border size
    ///   - color: color for border
    ///   - padding: padding for border and top
    func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: base.frame.width - padding*2, height: size, color: color)
    }
    
    /// GDExtension: Set only bottom border for view
    ///
    /// - Parameters:
    ///   - size: border size
    ///   - color: color for border
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: base.frame.height - size, width: base.frame.width, height: size, color: color)
    }
    
    /// GDExtension: Set only left border for view
    ///
    /// - Parameters:
    ///   - size: border size
    ///   - color: color for border
    func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: base.frame.height, color: color)
    }
    
    /// GDExtension: Set only right border for view
    ///
    /// - Parameters:
    ///   - size: border size
    ///   - color: color for borderbase.base.
    func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: base.frame.width - size, y: 0, width: size, height: base.frame.height, color: color)
    }
    
    /// GDExtension private func
    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        base.layer.addSublayer(border)
    }
    
    /// GDExtension: add tapGestureRecognizer
    var tap: UITapGestureRecognizer {
        if let _tap = objc_getAssociatedObject(self, &kUIViewTapKey) as? UITapGestureRecognizer {
            return _tap
        }
        let _tap = UITapGestureRecognizer()
        objc_setAssociatedObject(self, &kUIViewTapKey, _tap, .OBJC_ASSOCIATION_RETAIN)
        base.addGestureRecognizer(_tap)
        return _tap
    }
    
    /// GDExtension: animationForScaling
    ///
    /// - Parameter completion: completion
    func animationForScaling(_ completion: ((Bool) -> Void)?) {
        base.transform = CGAffineTransform.identity
        base.superview?.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.base.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.base.transform = CGAffineTransform.identity
            })
        }) { (finished) in
            self.base.superview?.isUserInteractionEnabled = true
            completion?(finished)
        }
    }
}

private var kUIViewTapKey: String = "com.gaodun.tapGestureRecognizer"
private var key = "com.gaodun.UIViewExpandKey"

#endif
