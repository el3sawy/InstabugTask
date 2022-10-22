//
//  CoreDataStorageMock.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation
import CoreData
@testable import InstabugNetworkClient

class CoreDataStorageMock: CoreDataStorage {
    
    #if TESTING
    override init() {
        super.init()
        persistentContainer = NSPersistentContainer(name: Constants.modelName)
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
       let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        viewContextBackground = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        viewContextBackground.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContextBackground.parent = mainContext
    }
    #endif
}
