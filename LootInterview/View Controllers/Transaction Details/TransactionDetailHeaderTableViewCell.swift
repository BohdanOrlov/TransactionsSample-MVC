//
//  TransactionDetailHeaderTableViewCell.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import SwiftDate

class TransactionDetailHeaderTableViewCell: UITableViewCell, Reusable, ConfigurableCell  {
    typealias T = Transaction
    
    @IBOutlet weak var ibStatusLabel: UILabel!
    @IBOutlet weak var ibDateLabel: UILabel!
    @IBOutlet weak var ibImageView: UIImageView!
    
    @IBOutlet weak var ibAmountLabel: UILabel!
    @IBOutlet weak var ibDescriptionLabel: UILabel!
    @IBOutlet weak var ibNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: Transaction, at indexPath: IndexPath) {
        ibStatusLabel.text = item.statusLabel
        ibDateLabel.text = item.settlementDate.toString(DateToStringStyles.dateTime(.medium))
        
        ibAmountLabel.text = Transaction.numberFormatter.string(from: item.amount as NSNumber)
        ibDescriptionLabel.text = item.description
        
    }
}
