//
//  Persist.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/8/18.
//  Copyright © 2018 motiveg. All rights reserved.
//

// Credit: Kilo Loco
// This solution was taken from this Youtube tutorial
// https://www.youtube.com/watch?v=tP4OGvIRUC4

import Foundation
import CoreData

class Persist {
    
    private init() {} // Credit: Kilo Loco; prevent instantiation
    
    // Credit: Kilo Loco; access context wherever needed
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    
    // Credit: Kilo Loco; access persistentContainer wherever needed
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MakeMeUp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // Credit: Kilo Loco; access saveContext() wherever needed
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
