//
//  TransactionsDetailsDataSource.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

class TransactionDetailsDataSource: NSObject, UITableViewDataSource {
    // MARK: - Internal Properties
    var item: Transaction
    
    // MARK: - Lifecycle
    init(transaction: Transaction) {
        item = transaction
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 1
        if let _ = item.coordinates {
            sections = 2
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = item.coordinates, indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MapPreviewTableViewCell.reuseIdentifier, for: indexPath) as! MapPreviewTableViewCell
            
            cell.configure(with: item, at: indexPath)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailHeaderTableViewCell.reuseIdentifier, for: indexPath) as! TransactionDetailHeaderTableViewCell
            
            cell.configure(with: item, at: indexPath)
            
            return cell
        }
        
    }
}
