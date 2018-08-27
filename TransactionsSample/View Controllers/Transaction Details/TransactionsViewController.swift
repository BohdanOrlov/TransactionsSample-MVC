//
//  TransactionsViewController.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var transaction: Transaction!
    var dataSource: TransactionDetailsDataSource!
    
    fileprivate func setupUI() {
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        dataSource = TransactionDetailsDataSource(transaction: transaction)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
}

extension TransactionDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
