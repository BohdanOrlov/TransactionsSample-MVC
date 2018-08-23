//
//  TransactionsDataSource.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 22/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

class TransactionsDataSource: NSObject, UITableViewDataSource {
    // MARK: - Internal Properties
    fileprivate var items: [Transaction] = []
    
    // MARK: - Lifecycle
    init(array: [Transaction]) {
        items = array.sorted(by: { $0.authorisationDate > $1.authorisationDate })
    }
    
    var numberOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> Transaction? {
        guard index >= 0, index < items.count else { return nil }
        
        return items[index]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        
        let transaction = items[indexPath.row]
        
        cell.configure(with: transaction, at: indexPath)
        
        return cell
    }
    
    
}
