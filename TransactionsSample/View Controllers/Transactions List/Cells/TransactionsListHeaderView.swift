//
//  TransactionsListHeaderView.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import SwiftDate

class TransactionsListHeaderView: UITableViewHeaderFooterView, Reusable, NibReusable {
    typealias T = Transaction
    
    @IBOutlet weak var ibTitleLabel: UILabel!
    @IBOutlet weak var ibAmountLabel: UILabel!
    
    func configure(with item: Group, at index: Int) {
        ibTitleLabel.text = item.date
        
        let totalAmount = item.models.map({ return $0.amount }).reduce(0, +)
        
        ibAmountLabel.text = Transaction.numberFormatter.string(from: totalAmount as NSNumber)
    }
}

extension TransactionsListHeaderView {
    class func height() -> CGFloat {
        return 50
    }
}
