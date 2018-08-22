//
//  ViewController.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

class TransactionsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: TransactionsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.delegate = self
        
        loadTransactions()
    }

    func loadTransactions() {
        let getTransactions = LootAPI.getTransactions
        
        _ = APIManager.loot.requestArray(Transaction.self, endpoint: getTransactions, completion: { [unowned self] (result) in
            switch result {
            case let .success(array):
                
                self.dataSource = TransactionsDataSource(array: array)
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
                
            case let .failure(error):
                print(error)
            }
        })
    }
}

extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
