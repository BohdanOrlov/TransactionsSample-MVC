//
//  Group.swift
//  TransactionsSample
//
//  Created by Thomas Angistalis on 27/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import RealmSwift
import SwiftDate

class Group: Object {
    @objc dynamic var date: String?
    @objc dynamic var absoluteDate: Date = Date(timeIntervalSinceReferenceDate: 0)
    
    let models = List<Transaction>()
    
    static override func primaryKey() -> String? {
        return "date"
    }
    
    static func add(_ transaction: Transaction) {
        let realm = try! Realm()
        
        let date = transaction.settlementDate.toString(DateToStringStyles.custom("dd MMMM yyyy"))
        
        if let group = realm.object(ofType: Group.self, forPrimaryKey: date) {
            try! realm.write {
                group.models.append(transaction)
            }
        } else {
            let group = Group()
            group.date = date
            group.absoluteDate = transaction.settlementDate
            group.models.append(transaction)
            
            try! realm.write {
                realm.add(group)
            }
        }
    }
}
