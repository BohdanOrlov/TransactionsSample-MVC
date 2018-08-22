//
//  Transaction.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation
import MapKit

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
    
    var amount: Int
    var description: String
    var postTransactionBalance: Int
    var settlementDate: Date
    var authorisationDate: Date
    
    var location: Location?
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        
        if let amountString = try? map.decode(String.self, forKey: .amount) {
            amount = Int(amountString) ?? 0
        } else {
            amount = 0
        }
        
        if let postTransactionBalanceString = try? map.decode(String.self, forKey: .postTransactionBalance) {
            postTransactionBalance = Int(postTransactionBalanceString) ?? 0
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
    var coordinates: CLLocationCoordinate2D? {
        guard let latitude = location?.latitude else { return nil }
        guard let longitude = location?.longitude else { return nil }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
