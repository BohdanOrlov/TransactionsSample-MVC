//
//  UIViewController.swift
//  TransactionsSample
//
//  Created by Thomas Angistalis on 27/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideBackButtonTitle() {
        let button = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = button
    }
}
