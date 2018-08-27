//
//  DependencyContainer.swift
//  Xapo
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation

import Moya
import RealmSwift

protocol Resetable {
    static func resetState()
}

/**
 Contains all singletons that can be ingected as dependencies.
 Tests will use a different configuration of this class.
**/
class DependencyContainer {

    private lazy var lootService = NetworkManager<LootAPI>(with: MoyaProvider<LootAPI>())
    
    init() {
        var config = Realm.Configuration()
        
        #if DEBUG
            if ProcessInfo.processInfo.isRunningUITests {
                config = Realm.Configuration(inMemoryIdentifier: "UITestingInMemoryRealm",
                                             deleteRealmIfMigrationNeeded: true)
            }
        #endif
        
        Realm.Configuration.defaultConfiguration = config
    }
}


extension DependencyContainer: ServicesFactory {

    /**
     - returns: The NetworkManager singleton instance.
     **/
    func makeLootService() -> NetworkManager<LootAPI> {
        return self.lootService
    }
}
