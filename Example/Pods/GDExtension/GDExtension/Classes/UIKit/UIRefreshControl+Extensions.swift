//
//  UIRefreshControl+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if os(iOS)
import UIKit

// MARK: - Methods
public extension GDReference where Base:  UIRefreshControl {

    /// GDExtension: Programatically begin refresh control inside of UITableView.
    ///
    /// - Parameters:
    ///   - tableView: UITableView instance, inside which the refresh control is contained.
    ///   - animated: Boolean, indicates that is the content offset changing should be animated or not.
    ///   - sendAction: Boolean, indicates that should it fire sendActions method for valueChanged UIControlEvents
    func beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        // https://stackoverflow.com/questions/14718850/14719658#14719658
        assert(base.superview == tableView, "Refresh control does not belong to the receiving table view")

        base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -base.frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            base.sendActions(for: .valueChanged)
        }
    }

}

#endif
