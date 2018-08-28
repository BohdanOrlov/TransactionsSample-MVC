//
//  MasterViewModelUnitTests.swift
//  MasterViewModelUnitTests
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import XCTest
import Moya
import RealmSwift

@testable import TransactionsSample

class RepositoriesViewModelUnitTests: XCTestCase {
    
    enum ResponseOverride {
        case sample
        case failure
    }
    
    private var container: MockingDependencyContainer!
    private var serverResponseOverride: ResponseOverride = .sample
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        MockingDependencyContainer.resetState()
        
        let endpointsClosure: MoyaProvider<LootAPI>.EndpointClosure = { (target: LootAPI) -> Endpoint in
            
            let sampleResponseClosure = { () -> EndpointSampleResponse in
                
                switch target {
                case .getTransactions:

                    switch self.serverResponseOverride {
                        
                    case .failure:
                        return .networkResponse(500, "Server Response".data(using: .utf8)!)
                        
                    default:
                        return .networkResponse(200, target.sampleData)
                    }
                }
            }
            
            // all the request properties should be the same as your default provider
            let url = URL(target: target).absoluteString
            let endpoint = Endpoint(url: url,
                                    sampleResponseClosure: sampleResponseClosure,
                                    method: target.method,
                                    task: target.task,
                                    httpHeaderFields: target.headers)
            return endpoint
        }
        
        let provider = MoyaProvider<LootAPI>(endpointClosure: endpointsClosure,
                                               stubClosure: MoyaProvider.immediatelyStub)
                
        container = MockingDependencyContainer(with: provider)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        container = nil
    }
    
    func testRepositoryParsing() {
        
        let service = container.makeLootService()
        
        let realm = try! Realm()
        XCTAssert(realm.objects(Group.self).count == 0, "Realm is not clean")
        
        expectation(forNotification: Transaction.Notifications.didFetchTransactions,
                    object: nil,
                    handler: nil)
        
        service.loadTransactions()
        
        waitForExpectations(timeout: 1.0) { (error) in
            guard error == nil else {
                XCTFail("Loading repositories timeout")
                return
            }
            
            // Load the sample objects
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            let sampleResponseWrapper = try! decoder.decode([Transaction].self, from: LootAPI.getTransactions.sampleData)
            
            let realm = try! Realm()
            
            let transactions = realm.objects(Group.self).flatMap({ $0.models }).sorted(by: { (t1, t2) -> Bool in
                t1.settlementDate > t2.settlementDate
            })
            
            XCTAssert(transactions.count == sampleResponseWrapper.count, "Failed to save all repos in Realm")
            
            for sampleTransaction in sampleResponseWrapper {
                let existing = transactions.filter({ $0.amount == sampleTransaction.amount }).first
                
                XCTAssert( existing?.amount == sampleTransaction.amount, "Repository parsing missmatch")
            }
        }
    }
    
    func testRepositoryLoadingFailure() {
        
        let service = container.makeLootService()
        
        let realm = try! Realm()
        XCTAssert(realm.objects(Group.self).count == 0, "Realm is not initialised clean")
        
        expectation(forNotification: Transaction.Notifications.didFailToFetchTransactions,
                    object: nil,
                    handler: nil)
        
        serverResponseOverride = .failure
        
        service.loadTransactions(service: service)
        
        waitForExpectations(timeout: 1.0) { (error) in
            guard error == nil else {
                XCTFail("Loading repositories timeout")
                return
            }
            
            let realm = try! Realm()
            
            XCTAssert(realm.objects(Group.self).count == 0, "Saved repos in Realm after failed request")
        }
    }
}
