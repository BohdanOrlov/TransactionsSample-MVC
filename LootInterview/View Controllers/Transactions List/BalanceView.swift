//
//  BalanceView.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

class BalanceView: UIView {

    @IBOutlet weak var ibTitleLabel: UILabel!
    @IBOutlet weak var ibSubtitleLabel: UILabel!
    
    func setBalance(with number: Float) {
        ibTitleLabel.text = Transaction.numberFormatter.string(from: number as NSNumber)
    }
}
