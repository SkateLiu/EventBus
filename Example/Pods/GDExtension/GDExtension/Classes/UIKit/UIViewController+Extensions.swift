//
//  UIViewController+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties
public extension GDReference where Base: UIViewController {

    /// GDExtension: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return base.isViewLoaded && base.view.window != nil
    }

}

// MARK: - Methods
public extension GDReference where Base: UIViewController {

    /// GDExtension: Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: string for notification name .
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: String, selector: Selector,_ object:Any? =  nil) {
        NotificationCenter.default.addObserver(base, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    /// GDExtension: Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: NSNotification.Name, selector: Selector,_ object:Any? =  nil) {
        NotificationCenter.default.addObserver(base, selector: selector, name: name, object: object)
    }

    /// GDExtension: Unassign as listener to notification.
    ///
    /// - Parameter name: string for notification name.
    func removeNotificationObserver(name: String) {
        NotificationCenter.default.removeObserver(base, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    /// GDExtension: Unassign as listener to notification.
    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: NSNotification.Name) {
        NotificationCenter.default.removeObserver(base, name: name, object: nil)
    }

    /// GDExtension: Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(base)
    }

    /// GDExtension: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult
    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil,_ highlightedIndex: Int? = nil,preferredStyle: UIAlertController.Style = .alert, clickAction: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                clickAction?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedIndex = highlightedIndex, index == highlightedIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        base.present(alertController, animated: true, completion: nil)
        return alertController
    }

    /// GDExtension: Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        base.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: base)
    }

    /// GDExtension: Helper method to remove a UIViewController from its parent.
    func removeViewAndControllerFromParentViewController() {
        guard base.parent != nil else { return }

        base.willMove(toParent: nil)
        base.removeFromParent()
        base.view.removeFromSuperview()
    }

    #if os(iOS)
    /// GDExtension: Helper method to present a UIViewController as a popover.
    ///
    /// - Parameters:
    ///   - popoverContent: the view controller to add as a popover.
    ///   - sourcePoint: the point in which to anchor the popover.
    ///   - size: the size of the popover. Default uses the popover preferredContentSize.
    ///   - delegate: the popover's presentationController delegate. Default is nil.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the presentation finishes. Default is nil.
    func presentPopover(_ popoverContent: UIViewController, sourcePoint: CGPoint, size: CGSize? = nil, delegate: UIPopoverPresentationControllerDelegate? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        popoverContent.modalPresentationStyle = .popover

        if let size = size {
            popoverContent.preferredContentSize = size
        }

        if let popoverPresentationVC = popoverContent.popoverPresentationController {
            popoverPresentationVC.sourceView = base.view
            popoverPresentationVC.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationVC.delegate = delegate
        }

        base.present(popoverContent, animated: animated, completion: completion)
    }
    #endif
    
    /// return the last presented vc
    func lastPresentedViewController() -> UIViewController? {
        var lastController: UIViewController?
        let currentController = base
        if currentController.presentedViewController != nil {
            lastController = currentController.presentedViewController
            lastController = lastController?.gd.lastPresentedViewController()
        } else {
            lastController = currentController
        }
        return lastController
    }

}

#endif
