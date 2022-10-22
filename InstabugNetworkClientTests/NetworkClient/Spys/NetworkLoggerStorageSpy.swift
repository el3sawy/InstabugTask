//
//  NetworkLoggerStorageMock.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation
@testable import InstabugNetworkClient

class NetworkLoggerStorageSpy {
    
    // MARK: - Testing Properties
    var networkModel: NetworkModel!
    var isSaveCalled = 0 // Set it zero here to make sure it called just once
    
}

// MARK: - Spy Functions
extension NetworkLoggerStorageSpy: NetworkLoggerStorageProtocol {
    
    func fetchRequests(completion: (([NetworkModel]) -> Void)) {
        completion([networkModel])
    }
    
    func save(_ item: NetworkModel, completion: ((NetworkEntity) -> Void)?) {
        isSaveCalled += 1
        networkModel = item
    }
}

