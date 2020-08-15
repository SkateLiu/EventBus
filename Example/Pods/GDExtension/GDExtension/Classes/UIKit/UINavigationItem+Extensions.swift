//
//  UINavigationItem+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base:  UINavigationItem {

    /// GDExtension: Replace title label with an image in navigation item.
    ///
    /// - Parameter image: UIImage to replace title with.
    func replaceTitle(with image: UIImage) {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        base.titleView = logoImageView
    }

}

#endif
