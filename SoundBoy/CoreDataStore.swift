//
//  CoreDataStack.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/30/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreData


enum EntitiesModel:String {
    case  user = "User"
    case  jam = "Jam"
    var toString:String {
        switch self {
        case .user:
            return String(self.rawValue)
        case .jam:
            return String(self.rawValue)
        }
        
    }
}

final class CoreDataStore:NSObject {
  
        
    let entity:EntitiesModel
    
     init(entity:EntitiesModel) {
        switch entity {
        case .jam:
            self.entity = .jam
        case .user:
            self.entity = .user
        }
    }
    
    var errorHandler: (Error) -> Void = {_ in }
        
        //#1
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "CoreData")
            container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
                if let error = error {
                    // MARK:TODO better error handling
                   print(error)
                    self?.errorHandler(error)
                }
            })
            return container
        }()
        
        //#2
        lazy var viewContext: NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()
        
        //#3
        // Optional
        lazy var backgroundContext: NSManagedObjectContext = {
            return self.persistentContainer.newBackgroundContext()
        }()
        
        //#4
        func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
            self.viewContext.perform {
                block(self.viewContext)
            }
        }
        
        //#5
        func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
            self.persistentContainer.performBackgroundTask(block)
        }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch  {
                let nserror = error as NSError
                fatalError("cant save contet \(nserror.userInfo)")
            }
        }
    }
    
}
