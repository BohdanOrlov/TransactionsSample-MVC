//
//  ViewController.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import SwiftDate
import ScrollableGraphView
import RealmSwift
import DZNEmptyDataSet

class TransactionsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceView: BalanceView!
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    var dataSource: TransactionsDataSource!
    
    var balancePoints: [Transaction] = []
    
    var isLoading = true
    
    fileprivate func setupGraphView() {
        graphView.dataSource = self
        
        let linePlot = LinePlot(identifier: "balance")
        linePlot.lineColor = UIColor.flatSkyBlue
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.flatSkyBlue
        linePlot.fillGradientEndColor = UIColor.white
        linePlot.lineWidth = 4
        
        let referenceLines = ReferenceLines()
        referenceLines.shouldShowReferenceLines = false
        
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.dataPointSpacing = 80
        graphView.direction = .rightToLeft
        
        graphView.reload()
    }
    
    fileprivate func setupUI() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.delegate = self
        
        tableView.registerReusableHeaderFooterView(TransactionsListHeaderView.self)
        
        setupGraphView()
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
        
        let realm = try! Realm()
        
        self.balancePoints = realm.objects(Group.self).flatMap({ $0.models }).sorted(by: { (t1, t2) -> Bool in
            t1.settlementDate < t2.settlementDate
        })
        
        graphView.reload()
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

extension TransactionsListViewController: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "balance":
            let item = balancePoints[pointIndex]
            
            return Double(item.postTransactionBalance)
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        let transaction = balancePoints[pointIndex]
        
        let date = transaction.settlementDate
        if date.year == Date().year {
            return date.toString(DateToStringStyles.custom("MMM d"))
        } else {
            return date.toString(DateToStringStyles.custom("MMM d, yyyy"))
        }
    }
    
    func numberOfPoints() -> Int {
        return balancePoints.count
    }
}

extension TransactionsListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        ]
        
        return NSAttributedString(string: "No Transactions Found", attributes: attributes)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            
            return activityIndicator
        }
        return nil
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -200/2
    }
}
