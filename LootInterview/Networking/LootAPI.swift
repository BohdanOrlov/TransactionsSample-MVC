//
//  LootAPI.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation
import Moya

enum LootAPI {
    case getTransactions
}

extension LootAPI: TargetType {
    var task: Task {
        return .requestPlain
    }
    
    var baseURL: URL { return URL(string: "http://private-710eeb-lootiosinterview.apiary-mock.com")! }

    var path: String {
        switch self {
        case .getTransactions:
            return "transactions"
        }
        
    }
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return nil
    }
}
