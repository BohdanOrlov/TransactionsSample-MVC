//
//  MockingDependencyContainer.swift
//  XapoTests
//
//  Created by Thomas Angistalis on 24/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation

import Moya
import RealmSwift

@testable import TransactionsSample

class MockingDependencyContainer {
    
    private let lootService: NetworkManager<LootAPI>
    
    init(with provider: MoyaProvider<LootAPI> = MoyaProvider<LootAPI>(stubClosure: MoyaProvider.immediatelyStub)) {
        // Configure the default realm
        let config = Realm.Configuration(inMemoryIdentifier: "TestingInMemoryRealm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        lootService = NetworkManager<LootAPI>(with: provider)
    }
}


extension MockingDependencyContainer: ServicesFactory {
    
    func makeLootService() -> NetworkManager<LootAPI> {
        return self.lootService
    }
}

extension MockingDependencyContainer: Resetable {
    
    static func resetState() {
                
        // Clean the Realm
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
