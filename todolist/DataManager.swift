//
//  DataManager.swift
//  todolist
//
//  Created by Виктория Козырева on 18.03.2021.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
//    static let key = "SAVE_DATA"
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func context() -> NSManagedObjectContext {
        return DataManager.shared.persistentContainer.viewContext
    }
    
    func saveContext() {
        if context().hasChanges {
            do {
                try context().save()
            } catch {
                context().rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
