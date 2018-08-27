//
//  Transaction.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation
import MapKit

struct Entry {
    
}

struct Location: Codable, Equatable {
    var latitude: Double?
    var longitude: Double?
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        if let latitudeString = try? map.decode(String.self, forKey: .latitude) {
            latitude = Double(latitudeString) ?? 0
        }
        if let longitudeString = try? map.decode(String.self, forKey: .longitude) {
            longitude = Double(longitudeString) ?? 0
        }
    }
}

struct Transaction: Codable, Equatable {
    
    var amount: Float
    var description: String
    var postTransactionBalance: Float
    var settlementDate: Date
    var authorisationDate: Date
    
    var location: Location?
    
    var statusLabel: String {
        return "Completed"
    }
    
    init(from decoder: Decoder) throws {
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
        
        description = try map.decode(String.self, forKey: .description)
        settlementDate = try map.decode(Date.self, forKey: .settlementDate)
        authorisationDate = try map.decode(Date.self, forKey: .authorisationDate)
        location = try map.decodeIfPresent(Location.self, forKey: .location)
    }
}

extension Transaction {
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
