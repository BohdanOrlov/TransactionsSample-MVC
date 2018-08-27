//
//  TransactionsListHeaderView.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import SwiftDate

class TransactionsListHeaderView: UITableViewHeaderFooterView, Reusable, ConfigurableCell, NibReusable {
    typealias T = Transaction
    
    @IBOutlet weak var ibDayLabel: UILabel!
    @IBOutlet weak var ibMonthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with item: Transaction, at indexPath: IndexPath) {

    }
    
}
