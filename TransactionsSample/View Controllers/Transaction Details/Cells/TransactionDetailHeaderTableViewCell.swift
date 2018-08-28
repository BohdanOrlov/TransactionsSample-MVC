//
//  TransactionDetailHeaderTableViewCell.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import SwiftDate
import ChameleonFramework

class TransactionDetailHeaderTableViewCell: UITableViewCell, Reusable, ConfigurableCell  {
    typealias T = Transaction
    
    @IBOutlet weak var ibStatusLabel: UILabel!
    @IBOutlet weak var ibDateLabel: UILabel!
    @IBOutlet weak var ibImageView: UIImageView!
    
    @IBOutlet weak var ibCategoryLabel: PaddingLabel!
    
    @IBOutlet weak var ibAmountLabel: UILabel!
    @IBOutlet weak var ibDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ibImageView.backgroundColor = UIColor(randomFlatColorOf: .light, withAlpha: 1.0)
        
        let color = UIColor.flatSkyBlue
        ibCategoryLabel.textColor = color
        ibCategoryLabel.layer.borderColor = color.cgColor
        ibCategoryLabel.layer.borderWidth = 1.0
    }

    func configure(with item: Transaction, at indexPath: IndexPath) {
        ibStatusLabel.text = item.statusLabel
        ibDateLabel.text = item.settlementDate.toString(DateToStringStyles.dateTime(.medium))
        
        ibAmountLabel.text = Transaction.numberFormatter.string(from: item.amount as NSNumber)
        ibDescriptionLabel.text = item.descriptionString
        
        ibCategoryLabel.text = item.categoryType.description.capitalized
    }
}
