//
//  NSManagedObject+Init.swift
//  InstabugNetworkClient
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation
import CoreData

public extension NSManagedObject {

    convenience init(using context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
