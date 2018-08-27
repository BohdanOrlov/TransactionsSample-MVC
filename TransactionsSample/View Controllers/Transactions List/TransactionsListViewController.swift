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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.delegate = self
        
        tableView.registerReusableHeaderFooterView(TransactionsListHeaderView.self)
        
        loadTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    func loadTransactions() {
        let getTransactions = LootAPI.getTransactions
        
        _ = APIManager.loot.requestArray(Transaction.self, endpoint: getTransactions, completion: { [unowned self] (result) in
            switch result {
            case let .success(array):
                
                self.dataSource = TransactionsDataSource(array: array)
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
                self.balanceView.isHidden = false
                
                if let first = self.dataSource.item(at: 0) {
                    self.balanceView.setBalance(with: first.postTransactionBalance)
                }
                
            case let .failure(error):
                print(error)
            }
        })
    }
}

extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource?.numberOfItems ?? 0 > 0 else {
            return UIView()
        }
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionsListHeaderView.reuseIdentifier) as? TransactionsListHeaderView else { return nil }
        
        cell.ibDayLabel.text = "\(Date().day)"
        cell.ibMonthLabel.text = Date().toString(DateToStringStyles.custom("MMMM yyyy"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource.item(at: indexPath.row)
        
        let controller = UIStoryboard.main.transactionDetails
        controller.transaction = item
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
