//
//  TransactionTableViewCell.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 22/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import ChameleonFramework

class TransactionTableViewCell: UITableViewCell, Reusable, ConfigurableCell, NibReusable {
    typealias T = Transaction
    
    /**
    I'm using the ib prefix for all IBOutlets to be easier for developers who are not familiar with the code base to be able to see all UI controls in code completion
    **/
    @IBOutlet weak var ibImageView: UIImageView!
    @IBOutlet weak var ibTitleLabel: UILabel!
    @IBOutlet weak var ibSubtitleLabel: UILabel!
    @IBOutlet weak var ibAmountLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ibAmountLabel.cornerRadius = 5
        ibImageView.backgroundColor = UIColor(randomFlatColorOf: .light, withAlpha: 1.0)
    }

    func configure(with item: Transaction, at indexPath: IndexPath) {

        ibTitleLabel.text = item.descriptionString
        ibSubtitleLabel.text = Transaction.timeFormatter.string(from: item.settlementDate)
        
        setAmount(with: item.amount)
    }
    
    fileprivate func setAmount(with number: Float) {
        ibAmountLabel.text = Transaction.numberFormatter.string(from: number as NSNumber)
        
        ibAmountLabel.textColor = number > 0 ? .white : .black
        ibAmountLabel.backgroundColor = number > 0 ? UIColor.flatGreen : .white
    }

}
