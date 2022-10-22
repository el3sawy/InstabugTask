//
//  NetworkLoggerStorage.swift
//  InstabugNetworkClient
//
//  Created by Ahmed Elesawy on 19/10/2022.
//

import Foundation
import CoreData

protocol NetworkLoggerStorageProtocol {
    func fetchRequests(completion: (([NetworkModel]) -> Void))
    func save(_ item: NetworkModel, completion: ((NetworkEntity) -> Void)?)
}

final class NetworkLoggerStorage {
    
    // MARK: - Properties
    private var counter: Int = 0
    let coreDataStorage: CoreDataStorage
    private let restriction: RestrictionNetworkProtocol
    
    // MARK: - Initializers
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared,
         restriction: RestrictionNetworkProtocol = RestrictionNetwork()) {
        self.coreDataStorage = coreDataStorage
        self.restriction = restriction
    }
}

// MARK: - Extension
extension NetworkLoggerStorage: NetworkLoggerStorageProtocol {
    
    func save(_ item: NetworkModel, completion: ((NetworkEntity) -> Void)? = nil ) {
        checker()
        
        coreDataStorage.viewContextBackground.performAndWait {
            let networkLogger = NetworkEntity(using: coreDataStorage.viewContextBackground)
            // Request
            networkLogger.method = item.method
            networkLogger.url = item.url
            networkLogger.requestPayload = item.requestPayload
            
            // Response
            networkLogger.statusCode = item.statusCode
            networkLogger.responsePayload = item.responsePayload
            networkLogger.errorDomain = item.errorDomain
            
            coreDataStorage.saveContext()
            completion?(networkLogger)
        }
        counter += 1
    }
    
    private func checker() {
        if counter >= restriction.countRecords {
            deleteFirstRecord()
        }
    }
    
   private func deleteFirstRecord() {
       coreDataStorage.fetch { result in
           if case .success( let records) = result {
               let firstRecord = records.first
               delete(record: firstRecord)
               counter -= 1
           }
       }
    }
    
    func fetchRequests(completion: (([NetworkModel]) -> Void)) {
        coreDataStorage.fetch { result in
            if case .success( let records) = result {
                let requests =  records.map(map(_:))
                completion(requests)
            }
        }
    }
    
    private func map(_ item: NetworkEntity) -> NetworkModel {
        return NetworkModel(method: item.method ?? "",
                            url:  item.url ?? "",
                            requestPayload: item.requestPayload,
                            statusCode: item.statusCode,
                            responsePayload: item.responsePayload,
                            errorDomain: item.errorDomain)
    }
    
    func delete(record: NetworkEntity?) {
        guard let record = record else { return }
        coreDataStorage.delete(item: record)
    }
}

