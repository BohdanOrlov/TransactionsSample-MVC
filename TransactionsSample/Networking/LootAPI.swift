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
        switch self {
        case .getTransactions:
            return Data.stubbedResponse("Transactions")
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

extension Data {
    
    /**
     Loads the sample response file from the bundle.
     **/
    static func stubbedResponse(_ filename: String) -> Data {
        @objc class TestClass: NSObject { }
        
        let bundle = Bundle(for: TestClass.self)
        
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            return Data()
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            #if DEBUG
            fatalError("Failed to load stubbed response: \(error.localizedDescription)")
            #else
            return Data()
            #endif
        }
    }
}
