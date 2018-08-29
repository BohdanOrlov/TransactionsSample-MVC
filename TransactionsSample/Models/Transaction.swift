//
//  Transaction.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import RealmSwift
import MapKit

enum TransactionCategory: Int, CustomStringConvertible {
    case general = 0
    case shopping
    case utilities
    case transfer
    
    public var description: String {
        switch self {
        case .transfer:
            return "Transfers"
        case .shopping:
            return "Shopping"
        case .utilities:
            return "Utilities"
        default:
            return "General"
        }
    }
}

class Transaction: RealmSwift.Object, Decodable {
    
    @objc dynamic var amount: Float = 0
    @objc dynamic var descriptionString: String = ""
    @objc dynamic var postTransactionBalance: Float = 0
    @objc dynamic var settlementDate: Date = Date.init(timeIntervalSinceReferenceDate: 0)
    @objc dynamic var authorisationDate: Date = Date.init(timeIntervalSinceReferenceDate: 0)
    
    @objc dynamic var location: Location?
    
    @objc dynamic var category: Int = 0
    
    var categoryType: TransactionCategory {
        return TransactionCategory(rawValue: category) ?? .general
    }
    
    var statusLabel: String {
        return "Completed"
    }
    
    enum CodingKeys: String, CodingKey {
        case descriptionString = "description"
        case amount, postTransactionBalance, settlementDate, authorisationDate, location
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let map = try decoder.container(keyedBy: CodingKeys.self)
        
        if let amountString = try? map.decode(String.self, forKey: .amount) {
            amount = Float(amountString) ?? 0
        } else {
            amount = 0
        }
        
        if let postTransactionBalanceString = try? map.decode(String.self, forKey: .postTransactionBalance) {
            postTransactionBalance = Float(postTransactionBalanceString) ?? 0
        } else {
            postTransactionBalance = 0
        }
        
        descriptionString = try map.decode(String.self, forKey: .descriptionString)
        settlementDate = try map.decode(Date.self, forKey: .settlementDate)
        authorisationDate = try map.decode(Date.self, forKey: .authorisationDate)
        location = try map.decodeIfPresent(Location.self, forKey: .location)
        
        if descriptionString.hasPrefix("From") {
            category = 3
        } else {
            category = Int(arc4random_uniform(UInt32(2)))
        }
    }
}

extension Transaction {
    public struct Notifications {
        
        /// Fired when results are loaded
        static let didFetchTransactions = UIKit.Notification.Name("didFetchTransactions")
        
        /// Fired when there is an error fetching the results
        static let didFailToFetchTransactions = UIKit.Notification.Name("didFailToFetchTransactions")
    }
    
    public static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_GB")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter
    }()
    
    public static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    var coordinates: CLLocationCoordinate2D? {
        guard let latitude = location?.latitude else { return nil }
        guard let longitude = location?.longitude else { return nil }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
