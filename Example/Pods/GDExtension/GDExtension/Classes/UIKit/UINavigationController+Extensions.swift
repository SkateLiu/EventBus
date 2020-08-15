//
//  UINavigationController+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base: UINavigationController {

    /// GDExtension: Pop ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition (default is true).
    ///   - completion: optional completion handler (default is nil).
    func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        animationTransaction(completion: completion, callBack: {
             self.base.popViewController(animated: animated)
        })
    }

    /// GDExtension: Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    func pushViewController(_ viewController: UIViewController, completion:(() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        animationTransaction(completion: completion, callBack: {
            self.base.pushViewController(viewController, animated: true)
        })
    }
    
    /// GDExtension: pop to given ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewControllerClass: viewController class to pop
    ///   - animated: Set this value to true to animate the transition (default is true).
    ///   - completion: optional completion handler (default is nil).
    func popToViewController(viewControllerClass: AnyClass,animated: Bool = true, _ completion: (() -> Void)? = nil)  {
        for viewController in base.viewControllers {
            if viewController.isKind(of: viewControllerClass){
                animationTransaction(completion: completion, callBack: {
                    self.base.popToViewController(viewController, animated: animated)
                })
            }
        }
    }
    
    /// GDExtension: removing the given count ViewControllers with completion handler.
    ///
    /// - Parameters:
    ///   - viewControllerClass: viewController class to pop
    ///   - animated: Set this value to true to animate the transition (default is true).
    ///   - completion: optional completion handler (default is nil).
    func popToIndexViewController(total: Int,animated: Bool = true, _ completion: (() -> Void)? = nil)  {
        let totalCount = base.viewControllers.count
        for index in 0..<total {
            if (totalCount-2-index<totalCount-1 && totalCount-2-index>0) {
                base.viewControllers.remove(at: totalCount-2-index)
            }
        }
        popViewController(animated: animated, completion)
    }
    
    /// GDExtension: push viewController and remove top n viewControllers
    /// - Parameters:
    ///   - viewController: to push viewController
    ///   - removeViewControllers: count of removing viewController
    ///   - animated: need animation
    ///   - completion: push completion callback
    func pushViewController(viewController: UIViewController, removeViewControllers: Int,animated: Bool = true, _ completion: (() -> Void)? = nil)  {
        let totalCount = base.viewControllers.count
        for index in 0..<removeViewControllers {
            if (totalCount-2-index<totalCount-1 && totalCount-2-index>0) {
                base.viewControllers.remove(at: totalCount-2-index)
            }
        }
        pushViewController(viewController, completion: completion)
    }
    
    private func animationTransaction(completion:(() -> Void)? = nil,callBack: (() -> Void)? = nil){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        callBack?()
        CATransaction.commit()
    }

    /// GDExtension: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white) {
        base.navigationBar.setBackgroundImage(UIImage(), for: .default)
        base.navigationBar.shadowImage = UIImage()
        base.navigationBar.isTranslucent = true
        base.navigationBar.tintColor = tint
        base.navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }

}

#endif
