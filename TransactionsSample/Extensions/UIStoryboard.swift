//
//  UIStoryboard.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    var transactionDetails: TransactionDetailsViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "TransactionDetailsViewController") as! TransactionDetailsViewController
    }
}
