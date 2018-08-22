//
//  AppExtensions.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 22/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

extension UITableView {
    /**
     Gets the reusable cell with the specified identifier name.
     - parameter indexPath: The index path of the cell from the table.
     - parameter identifier: Name of the reusable cell identifier.
     - returns: Returns the table view cell.
     */
    public subscript(indexPath: IndexPath, reuseIdentifier: String) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: NibReusable {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibReusable {
        self.register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: NibReusable&Reusable {
        self.register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol NibReusable: Reusable {
    static var nib: UINib { get }
}

extension NibReusable {
    public static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

public protocol ConfigurableCell: Reusable {
    associatedtype T
    
    func configure(with item: T, at indexPath: IndexPath)
}
