//
//  TransactionsDataSource.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 22/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionsDataSource: NSObject, UITableViewDataSource {
    // MARK: - Internal Properties
    
    fileprivate var items: Results<Group>!
    
    // MARK: - Lifecycle

    override init() {
        super.init()
        
        let realm = try! Realm()
        
        items = realm.objects(Group.self).sorted(byKeyPath: "absoluteDate", ascending: false)
    }
    
    // MARK: - Helpers
    
    var numberOfSections: Int {
        return items.count
    }
    
    func group(at index: Int) -> Group {
        return items[index]
    }
    
    func transaction(at indexPath: IndexPath) -> Transaction? {
        let group = items[indexPath.section]
        
        return group.models[indexPath.row]
    }
    
    // MARK: - UITableView Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        
        return item.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        
        let group = items[indexPath.section]
        
        let transaction = group.models[indexPath.row]
        
        cell.configure(with: transaction, at: indexPath)
        
        return cell
    }
}
