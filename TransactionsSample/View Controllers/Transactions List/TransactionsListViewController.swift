//
//  ViewController.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import SwiftDate

class TransactionsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceView: BalanceView!
    
    var dataSource: TransactionsDataSource!
    
    fileprivate func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.delegate = self
        
        tableView.registerReusableHeaderFooterView(TransactionsListHeaderView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hideBackButtonTitle()
        
        setupUI()
        
        loadTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func reloadDataSource() {
        self.dataSource = TransactionsDataSource()
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
        self.balanceView.isHidden = false
        
        if let first = self.dataSource.transaction(at: IndexPath(row: 0, section: 0)) {
            self.balanceView.setBalance(with: first.postTransactionBalance)
        }
    }

    func loadTransactions() {
        _ = APIManager.loot.loadTransactions(completion: { [weak self] (success) in
            guard let `self` = self else { return }
            
            if success {
                self.reloadDataSource()
            }
        })
    }
}

extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource?.numberOfSections ?? 0 > 0 else {
            return UIView()
        }
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionsListHeaderView.reuseIdentifier) as? TransactionsListHeaderView else { return nil }
        
        let group = dataSource.group(at: section)
        
        cell.configure(with: group, at: section)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource.transaction(at: indexPath)
        
        let controller = UIStoryboard.main.transactionDetails
        controller.transaction = item
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
