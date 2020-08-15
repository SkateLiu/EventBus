//
//  UITableView+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties
public extension GDReference where Base: UITableView {

    /// GDExtension: Index path of last row in tableView.
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

    /// GDExtension: Index of last section in tableView.
    var lastSection: Int? {
        return base.numberOfSections > 0 ? base.numberOfSections - 1 : nil
    }

}

// MARK: - Methods
public extension GDReference where Base: UITableView {

    /// GDExtension: Number of all rows in all sections of tableView.
    ///
    /// - Returns: The count of all rows in the tableView.
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < base.numberOfSections {
            rowCount += base.numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }

    /// GDExtension: IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard base.numberOfSections > 0, section >= 0 else { return nil }
        guard base.numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: base.numberOfRows(inSection: section) - 1, section: section)
    }

    /// GDExtension: Remove TableFooterView.
    func removeTableFooterView() {
        base.tableFooterView = nil
    }

    /// GDExtension: Remove TableHeaderView.
    func removeTableHeaderView() {
        base.tableHeaderView = nil
    }

    /// GDExtension: Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: base.contentSize.height - base.bounds.size.height)
        base.setContentOffset(bottomOffset, animated: animated)
    }

    /// GDExtension: Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        base.setContentOffset(CGPoint.zero, animated: animated)
    }

    /// GDExtension: Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// GDExtension: Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// GDExtension: Dequeue reusable UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    /// - Returns: UITableViewHeaderFooterView object with associated class name.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }

    /// GDExtension: Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        base.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// GDExtension: Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        base.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// GDExtension: Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        base.register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    /// GDExtension: Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        base.register(nib, forCellReuseIdentifier: String(describing: name))
    }

    /// GDExtension: Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        base.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    /// GDExtension: Check whether IndexPath is valid within the tableView
    ///
    /// - Parameter indexPath: An IndexPath to check
    /// - Returns: Boolean value for valid or invalid IndexPath
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
            indexPath.section < base.numberOfSections &&
            indexPath.row < base.numberOfRows(inSection: indexPath.section)
    }

    /// GDExtension: Safely scroll to possibly invalid IndexPath
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to
    ///   - scrollPosition: Scroll position
    ///   - animated: Whether to animate or not
    func scrollToRowSafely(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < base.numberOfSections else { return }
        guard indexPath.row < base.numberOfRows(inSection: indexPath.section) else { return }
        base.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    /// Retrive all the IndexPaths for the section.
    ///
    /// - Parameter section: The section.
    /// - Returns: Return an array with all the IndexPaths.
    func indexPaths(section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        let rows: Int = base.numberOfRows(inSection: section)
        for index in 0 ..< rows {
            let indexPath = IndexPath(row: index, section: section)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    /// Retrive the next index path for the given row at section.
    ///
    /// - Parameters:
    ///   - row: Row of the index path.
    ///   - section: Section of the index path
    /// - Returns: Returns the next index path.
    func nextIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row + 1]
    }
    
    /// Retrive the previous index path for the given row at section
    ///
    /// - Parameters:
    ///   - row: Row of the index path.
    ///   - section: Section of the index path.
    /// - Returns: Returns the previous index path.
    func previousIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row - 1]
    }

}

public extension UITableView{
    
    /// Create an UITableView and set some parameters
    ///
    /// - Parameters:
    ///   - frame: TableView frame.
    ///   - style: TableView style.
    ///   - cellSeparatorStyle: Cell separator style.
    ///   - separatorInset: Cell separator inset.
    ///   - dataSource: TableView data source.
    ///   - delegate: TableView delegate.
    convenience init(
        frame: CGRect  = CGRect.zero,
        style: UITableView.Style = .plain,
        cellSeparatorStyle: UITableViewCell.SeparatorStyle = .none,
        separatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        dataSource: UITableViewDataSource?,
        delegate: UITableViewDelegate?) {
        self.init(frame: frame, style: style)
        separatorStyle = cellSeparatorStyle
        self.separatorInset = separatorInset
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

#endif
