//
//  UIApplication+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit)
import UIKit

#if os(iOS) || os(tvOS)

public extension GDReference where Base: UIApplication{
    
    /// GDExtension: Application running environment.
    ///
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        case debug
        case testFlight
        case appStore
    }
    
    /// GDExtension: Current inferred app environment.
    var inferredEnvironment: Environment {
        #if DEBUG
        return .debug
        
        #elseif targetEnvironment(simulator)
        return .debug
        
        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }
        
        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }
        
        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }
        
        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }
        
        return .appStore
        #endif
    }
    
    /// GDExtension: Application name (if applicable).
    var displayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    /// GDExtension: App current build number (if applicable).
    var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    /// GDExtension: App's current version number (if applicable).
    var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
}

public extension UIApplication {

    /// GDExtension: App's current vc 😏
    @objc func currentController() -> UIViewController? {
        var currentController: UIViewController?
        var rootController = UIApplication.shared.delegate?.window??.rootViewController
        
        repeat {
            if rootController?.isKind(of: UINavigationController.self) ?? false {
                let navigationController = rootController as? UINavigationController
                rootController = navigationController?.topViewController
                
            } else if rootController?.isKind(of: UITabBarController.self) ?? false {
                let tabbarController = rootController as? UITabBarController
                rootController = tabbarController?.selectedViewController
                
            } else if rootController?.presentedViewController != nil {
                let temp = rootController
                rootController = rootController?.presentedViewController
                if !(rootController?.isKind(of: UINavigationController.self) ?? false),
                    (rootController?.definesPresentationContext == true || rootController?.isKind(of: UIAlertController.self) ?? false) {
                    currentController = temp
                    break
                }
            } else {
                currentController = rootController
                break
            }
            
        } while rootController != nil
        
        return currentController
    }

}
#endif

#endif
