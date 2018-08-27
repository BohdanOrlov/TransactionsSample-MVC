//
//  SearchResultsTableViewController.swift
//  TransactionsSample
//
//  Created by Thomas Angistalis on 27/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    
    var dataSource: TransactionsDataSource! {
        didSet {
            tableView.dataSource = dataSource
            tableView?.reloadData()
        }
    }
    
    fileprivate func setupUI() {
        title = "Search"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
        let dataSource = TransactionsDataSource()
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        tableView.registerReusableHeaderFooterView(TransactionsListHeaderView.self)
        tableView.register(TransactionTableViewCell.nib, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()

        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchResultsTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource?.numberOfSections ?? 0 > 0 else {
            return UIView()
        }
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionsListHeaderView.reuseIdentifier) as? TransactionsListHeaderView else { return nil }
        
        let group = dataSource.group(at: section)
        
        cell.configure(with: group, at: section)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource.transaction(at: indexPath)
        
        let controller = UIStoryboard.main.transactionDetails
        controller.transaction = item
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchResultsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        let filteredDatasource = TransactionsDataSource()
        filteredDatasource.searchTerm = searchController.searchBar.text
        dataSource = filteredDatasource
        
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}
