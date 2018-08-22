//
//  Transaction.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation

struct Location: Codable, Equatable {
    var latitude: String
    var longitude: String
}

struct Transaction: Codable, Equatable {
    
    var amount: String
    var description: String
    var postTransactionBalance: String
    var settlementDate: Date
    var authorisationDate: Date
    
    var location: Location?
}
