//
//  CoreDataStorage.swift
//  InstabugNetworkClient
//
//  Created by Ahmed Elesawy on 19/10/2022.
//

import Foundation
import CoreData

protocol CoreDataStorageProtocol {
    func saveContext()
    func delete(item: NetworkEntity)
    func fetch(completion: ((Result<[NetworkEntity], Error>) -> Void))
}

public class CoreDataStorage {
    
    // MARK: - Properties
    public static let shared = CoreDataStorage()
    var persistentContainer = NSPersistentContainer(name: Constants.modelName)
    var viewContextBackground = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private lazy var persistentCoordinator = persistentContainer.persistentStoreCoordinator
    
    // MARK: - Init
    #if TESTING
    init() {
        setPersistentContainer()
    }
    #else
    private init() {
        setPersistentContainer()
    }
    #endif
    
    // MARK: - Functions
    private func setPersistentContainer() {
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContextBackground.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContextBackground.parent = viewContext
    }
    
}

// MARK: - Extension
extension CoreDataStorage: CoreDataStorageProtocol {
    func saveContext() {
        viewContextBackground.performAndWait {
            saveBackgroundMode()
        }
    }
    
    private func saveBackgroundMode() {
        if viewContextBackground.hasChanges {
            do {
                try viewContextBackground.save()
                try persistentContainer.viewContext.save()
            }
            catch {
                print("Error in save background \(error)")
            }
        }
    }
    
    func delete(item: NetworkEntity) {
        viewContextBackground.performAndWait {
                viewContextBackground.delete(item)
                saveContext()
        }
    }
    
    func fetch(completion: ((Result<[NetworkEntity], Error>) -> Void)) {
        viewContextBackground.performAndWait {
            do {
                let items = try viewContextBackground.fetch(NetworkEntity.fetchRequest())
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func reset() {
        viewContextBackground.performAndWait {
            // We have just one persistent store
            guard let loggerStore = persistentCoordinator.persistentStores.first else { return }
            deletePersistentStore(loggerStore)
            setPersistentContainer()
        }
    }
    
    private func deletePersistentStore(_ store: NSPersistentStore) {
        do{
            try persistentCoordinator.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
        }
        catch {
            print(error)
        }
    }
}
