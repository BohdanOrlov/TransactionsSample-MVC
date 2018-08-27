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
    var categoryFilterType: TransactionCategory? {
        didSet {
            self.reload()
        }
    }
    
    var searchTerm: String? {
        didSet {
            self.reload()
        }
    }
    
    var items: Results<Group>!
    
    // MARK: - Lifecycle

    override init() {
        super.init()
        
        reload()
    }
    
    func reload() {
        let realm = try! Realm()
        
        if let filter = categoryFilterType {
            items = realm.objects(Group.self).filter("ANY models.category = \(filter.rawValue)").sorted(byKeyPath: "absoluteDate", ascending: false)
        } else if let search = searchTerm, search.count > 0 {
            items = realm.objects(Group.self).filter("ANY models.descriptionString CONTAINS '\(search)'").sorted(byKeyPath: "absoluteDate", ascending: false)
        } else {
            items = realm.objects(Group.self).sorted(byKeyPath: "absoluteDate", ascending: false)
        }
    }
    
    // MARK: - Helpers
    
    var numberOfSections: Int {
        return items.count
    }
    
    func group(at index: Int) -> Group {
        return items[index]
    }
    
    func transaction(at indexPath: IndexPath) -> Transaction? {
        guard items.count > 0, indexPath.section < items.count else { return nil }
        
        let group = items[indexPath.section]
        
        guard group.models.count > 0, indexPath.row < group.models.count else { return nil }
        
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
