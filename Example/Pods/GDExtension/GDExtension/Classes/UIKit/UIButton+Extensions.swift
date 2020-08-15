//
//  UIButton+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit
import Foundation

// MARK: - Properties
public extension UIButton {

    /// GDExtension: Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }

    /// GDExtension: Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }

    /// GDExtension: Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }

    /// GDExtension: Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }

    /// GDExtension: Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }

    /// GDExtension: Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }

    /// GDExtension: Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }

    /// GDExtension: Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }

    /// GDExtension: Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }

    /// GDExtension: Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }

    /// GDExtension: Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }

    /// GDExtension: Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }

}

/// This extesion adds some useful functions to UIButton.
public extension UIButton {
    // MARK: - Functions
    
    /// Create an UIButton in a frame with a title, a background image and highlighted background image.
    ///
    /// - Paramters:
    ///   - frame: Button frame.
    ///   - title: Button title.
    ///   - backgroundImage: Button background image.
    ///   - highlightedBackgroundImage: Button highlighted background image.
    convenience init(title: String?, backgroundImage: UIImage? = nil, highlightedBackgroundImage: UIImage? = nil) {
        self.init(frame: CGRect.zero)
        self.frame = CGRect.zero
        setTitle(title, for: UIControl.State.normal)
        setBackgroundImage(backgroundImage, for: UIControl.State.normal)
        setBackgroundImage(highlightedBackgroundImage, for: UIControl.State.highlighted)
    }
    
    /// Create an UIButton in a frame with a title and a color.
    ///
    /// - Parameters:
    ///   - frame: Button frame.
    ///   - title: Button title.
    ///   - color: Button color
    convenience init(title: String?, backgroundColor: UIColor?) {
        self.init(title: title)
        self.backgroundColor = backgroundColor
    }
    
    /// Create an UIButton in a frame with a title and a color.
    ///
    /// - Parameters:
    ///   - frame: Button frame.
    ///   - title: Button title.
    ///   - color: Button color, the highlighted color will be automatically created.
    convenience init(title: String?, backgroundColor: UIColor?,_ titleColor:UIColor? = UIColor.black,_ image: UIImage?,_ font:UIFont?,_ cornerRadius:CGFloat? = 0) {
        guard let components: UnsafePointer<CGFloat> = backgroundColor?.cgColor.__unsafeComponents else {
            self.init( title: title)
            return
        }
        
        self.init(title: title, backgroundImage: UIImage(color: backgroundColor ?? UIColor.white), highlightedBackgroundImage: UIImage(color: UIColor(red: components[0] - 0.1, green: components[1] - 0.1, blue: components[2] - 0.1, alpha: 1)))
        self.setTitleColor(titleColor, for: .normal)
        self.setImage(image, for: .normal)
        self.titleLabel?.font = font
        self.cornerRadius = cornerRadius ?? 0
    }
    
    
    /// Create an UIButton in a frame with a title, a color and highlighted color.
    ///
    /// - Parameters:
    ///   - frame: Button frame.
    ///   - title: Button title.
    ///   - color: Button color.
    ///   - highlightedColor: Button highlighted color.
    convenience init(title: String?, color: UIColor?, highlightedColor: UIColor?) {
        self.init(title: title, backgroundImage: UIImage(color: color ?? UIColor.white), highlightedBackgroundImage: UIImage(color: highlightedColor ?? UIColor.white))
    }
    
    /// Create an UIButton in a frame with an image
    ///
    /// - Parameters:
    ///   - frame: Button frame
    ///   - image: Button image
    ///   - highlightedImage: Button highlighted image
    convenience init(image: UIImage?, highlightedImage: UIImage? = nil) {
        self.init(frame: CGRect.zero)
        self.frame = CGRect.zero
        setImage(image, for: UIControl.State.normal)
        setImage(highlightedImage, for: UIControl.State.highlighted)
    }
    
}
public extension GDReference where Base: UIButton {
    /// Set the title font with a size.
    ///
    /// - Parameters:
    ///   - fontName: Font name from the FontName enum declared in UIFontExtension.
    ///   - size:Font size.
    @discardableResult
    func setTitleFont(_ fontName: FontName, size: CGFloat) -> GDReference {
        if let titleLabel = base.titleLabel {
            titleLabel.font = UIFont(fontName: fontName, size: size)
        }
        return self
    }
    
    /// Set the title color.
    ///
    /// - Parameter color: Font color, the highlighted color will be automatically created.
    @discardableResult
    func setTitleColor(_ color: UIColor) -> GDReference {
        setTitleColor(color, highlightedColor: color.withAlphaComponent(0.4))
        return self
    }
    
    /// Set the title color and highlighted color
    ///
    /// - Parameters:
    ///   - color: Button color
    ///   - highlightedColor: Button highlighted color
    @discardableResult
    func setTitleColor(_ color: UIColor, highlightedColor: UIColor) -> GDReference {
        base.setTitleColor(color, for: UIControl.State.normal)
        base.setTitleColor(highlightedColor, for: UIControl.State.highlighted)
        return self
    }
    
    /// Set the back color and highlighted color for btn
    ///
    /// - Parameters:
    ///   - color: Button back color
    ///   - forState: Button state
    @discardableResult
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) -> GDReference {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        base.setBackgroundImage(colorImage, for: forState)
        return self
    }
    
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    /// GDExtension: Set image for all states.
    ///
    /// - Parameter image: UIImage.
    func setImageForAllStates(_ image: UIImage) {
        states.forEach { base.setImage(image, for: $0) }
    }
    
    /// GDExtension: Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { base.setTitleColor(color, for: $0) }
    }
    
    /// GDExtension: Set title for all states.
    ///
    /// - Parameter title: title string.
    func setTitleForAllStates(_ title: String) {
        states.forEach { base.setTitle(title, for: $0) }
    }
    
    /// GDExtension: Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        base.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
// MARK: - Add Block With Btn
public extension UIButton {
    
    typealias BtnAction = (UIButton)->()
    
    private struct AssociatedKeys{
        static var actionKey = "GDBtnActionKey"
    }
    
    @discardableResult func addTargetTouchUpInSideBtnAction(_ action:@escaping BtnAction) -> UIButton{
        self.btnAddAction(action: action, for: .touchUpInside)
        return self
    }
    
    @discardableResult func addTargetTouchUpOutSideBtnAction(_ action:@escaping BtnAction) -> UIButton{
        self.btnAddAction(action: action, for: .touchUpOutside)
        return self
    }
    
    @discardableResult func addTargetTouchCancelBtnAction(_ action:@escaping BtnAction) -> UIButton{
        self.btnAddAction(action: action, for: .touchCancel)
        return self
    }
    
    @objc private dynamic var actionDic: NSMutableDictionary? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        
        get{
            if let dic = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? NSDictionary{
                return NSMutableDictionary.init(dictionary: dic)
            }
            return nil
        }
    }
    
    @objc dynamic private func btnAddAction(action:@escaping  BtnAction ,for controlEvents: UIControl.Event) {
        let eventStr = NSString.init(string: String.init(describing: controlEvents.rawValue))
        if let actions = self.actionDic {
            actions.setObject(action, forKey: eventStr)
            self.actionDic = actions
        }else{
            self.actionDic = NSMutableDictionary.init(object: action, forKey: eventStr)
        }
        
        switch controlEvents {
        case .touchUpInside:
            self.addTarget(self, action: #selector(touchUpInSideBtnAction), for: .touchUpInside)
        case .touchUpOutside:
            self.addTarget(self, action: #selector(touchUpOutsideBtnAction), for: .touchUpOutside)
        case .touchCancel:
            self.addTarget(self, action: #selector(touchCancelBtnAction), for: .touchCancel)
            break
            
        default:
            break
        }
    }
    
    @objc private func touchCancelBtnAction(btn: UIButton) {
        
        if let actionDic = self.actionDic  {
            if let touchCancelBtnAction = actionDic.object(forKey: String.init(describing: UIControl.Event.touchCancel.rawValue)) as? BtnAction{
                touchCancelBtnAction(self)
            }
        }
    }
    @objc private func touchUpInSideBtnAction(btn: UIButton) {
        
        if let actionDic = self.actionDic  {
            if let touchUpInSideAction = actionDic.object(forKey: String.init(describing: UIControl.Event.touchUpInside.rawValue)) as? BtnAction{
                touchUpInSideAction(self)
            }
        }
    }
    
    @objc private func touchUpOutsideBtnAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpOutsideBtnAction = actionDic.object(forKey:   String.init(describing: UIControl.Event.touchUpOutside.rawValue)) as? BtnAction{
                touchUpOutsideBtnAction(self)
            }
        }
    }
}
///ExpandResponseArea
public extension UIButton {
    
    /// that primey key for runtime key
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
    }
    
    /// u can set a UIEdgeInsets for but, then button expand response area will change 😝😝😝
    var clickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    
    
    /// override this func to set response area
    /// - Parameters:
    ///   - point: touch point in view
    ///   - event: someting UIEvent
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        if (clickEdgeInsets != nil) {
            let x: CGFloat = -(clickEdgeInsets?.left ?? 0)
            let y: CGFloat = -(clickEdgeInsets?.top ?? 0)
            let width: CGFloat = bounds.width + (clickEdgeInsets?.left ?? 0) + (clickEdgeInsets?.right ?? 0)
            let height: CGFloat = bounds.height + (clickEdgeInsets?.top ?? 0) + (clickEdgeInsets?.bottom ?? 0)
            bounds = CGRect(x: x, y: y, width: width, height: height)
        }
        return bounds.contains(point)
    }
}
#endif
