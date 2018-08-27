//
//  Location.swift
//  TransactionsSample
//
//  Created by Thomas Angistalis on 28/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import RealmSwift

class Location: RealmSwift.Object, Codable {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let map = try decoder.container(keyedBy: CodingKeys.self)
        if let latitudeString = try? map.decode(String.self, forKey: .latitude) {
            latitude = Double(latitudeString) ?? 0
        }
        if let longitudeString = try? map.decode(String.self, forKey: .longitude) {
            longitude = Double(longitudeString) ?? 0
        }
    }
}
