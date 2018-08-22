//
//  APIManager.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 21/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation
import Moya
import Result

public let queueIdentifier = "com.angistalis.loot"

public struct APIManager {
    static var sharedManager = APIManager()
    
    static let loot = NetworkManager<LootAPI>()
}

public class NetworkManager<Target> where Target: TargetType {
    
    let provider: MoyaProvider<Target>!
    
    var responseQueue: DispatchQueue
    
    public init(queue: String = queueIdentifier, endpointClosure: ((Target) -> Endpoint)? = nil) {
        
        self.responseQueue = DispatchQueue(label: queueIdentifier, attributes: DispatchQueue.Attributes.concurrent)
        
        self.provider = MoyaProvider<Target>()
    }
    
    func request(
        _ target: Target,
        queue: DispatchQueue? = nil,
        completion completionClosure: ((Result<Data, Moya.MoyaError>) -> Void)? = nil
        ) -> Cancellable {
        
        return provider.request(target, callbackQueue: responseQueue) { result in
            autoreleasepool {
                switch result {
                case let .success(response):
                    do {
                        let json = response.data
                        
                        #if DEBUG
                        Logger.log(level: .verbose, message: String(data: json, encoding: .utf8) ?? "")

                        #endif
                        
                        _ = try response.filterSuccessfulStatusCodes()
                        
                        let queue = queue ?? self.responseQueue
                        queue.async {
                            completionClosure?(.success(json))
                        }
                    } catch {
                        // show an error to your user
                        Logger.log(level: .error, message: error)
                        
                        let queue = queue ?? self.responseQueue
                        queue.async {
                            completionClosure?(.failure( MoyaError.statusCode(response)))
                        }
                    }
                case let .failure(error):
                    
                    let queue = queue ?? self.responseQueue
                    queue.async {
                        completionClosure?(.failure( error ) )
                    }
                }
            }
        }
    }
    
    // MARK: Generic Requests
    
    func requestArray<T: Decodable>(_ type: T.Type,
                                    endpoint: Target,
                                    queue: DispatchQueue = DispatchQueue.main,
                                    completion completionClosure: ((Result<[T], Moya.MoyaError>) -> Void)? = nil
        ) -> Cancellable {
        
        return self.request(endpoint) { completionType in
            autoreleasepool {
                switch completionType {
                case let .success(json):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        
                        let array = try decoder.decode([T].self, from: json)
                        
                        queue.async {
                            completionClosure?( .success(array) )
                        }
                        
                    } catch {
                        Logger.log(level: .error, message: error)
                        queue.async {
                            completionClosure?( .failure( .underlying(error, nil)) )
                        }
                    }
                case let .failure(error):
                    queue.async {
                        completionClosure?( .failure(error) )
                    }
                }
            }
            
        }
    }
    
    func requestObject<T: Decodable>(_ type: T.Type,
                                     endpoint: Target,
                                     queue: DispatchQueue = DispatchQueue.main,
                                     completion completionClosure: ((Result<T, Moya.MoyaError>) -> Void)? = nil
        ) -> Cancellable {
        
        return self.request(endpoint) { completionType in
            autoreleasepool {
                switch completionType {
                case let .success(json):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        
                        let object = try decoder.decode(T.self, from: json)
                        queue.async {
                            completionClosure?( .success(object) )
                        }
                        
                    } catch {
                        Logger.log(level: .error, message: error)
                        queue.async {
                            completionClosure?( .failure( .underlying(error, nil)) )
                        }
                    }
                case let .failure(error):
                    queue.async {
                        completionClosure?( .failure(error) )
                    }
                }
            }
        }
    }
}
