//
//  UIStoryboard+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit)  && !os(watchOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base:  UIStoryboard {

    /// GDExtension: Get main storyboard for application
    static var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }

    /// GDExtension: Instantiate a UIViewController using its class name
    ///
    /// - Parameter name: UIViewController type
    /// - Returns: The view controller corresponding to specified class name
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return base.instantiateViewController(withIdentifier: String(describing: name)) as? T
    }

}

#endif
