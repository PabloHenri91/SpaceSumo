//
//  MemoryCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/9/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import CoreData

class MemoryCard {
    
    static let sharedInstance = MemoryCard()
    
    var autoSave:Bool = false
    
    var playerData:PlayerData!
    
    init() {
        self.load()
    }
    
    func new() {
        print("Creating new game...")
        
        self.playerData = PlayerData.insertNew(inManagedObjectContext: self.managedObjectContext)
        
        self.autoSave = true
    }
    
    func save() {
        if(self.autoSave) {
            self.autoSave = false
            print("Saving game...")
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func load() {
        if let _ = self.playerData {
            print("Game already loaded.")
        } else {
            let fetchRequestData:NSArray = self.fetchRequest()
            
            if(fetchRequestData.count > 0) {
                print("Loading game...")
                
                for item in fetchRequestData {
                    self.playerData = item as! PlayerData
                }
                
                self.autoSave = true
            } else {
                self.new()
            }
        }
    }
    
    func delete() {
        print("MemoryCard.delete()")
        
        let fetchRequestData:NSArray = fetchRequest()
        
        for item in fetchRequestData {
            self.managedObjectContext.deleteObject(item as! NSManagedObject)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.new()
    }
    
    func fetchRequest() -> [AnyObject] {
        let fetchRequest = self.managedObjectModel.fetchRequestTemplateForName("FetchRequest")!
        let fetchRequestData = try! self.managedObjectContext.executeFetchRequest(fetchRequest)
        return fetchRequestData
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PabloHenri91.Game" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        //let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("GameData.sqlite")
        let url = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("GameData.sqlite")
        
        let options = Dictionary(dictionaryLiteral:
            (NSMigratePersistentStoresAutomaticallyOption, true),
            (NSInferMappingModelAutomaticallyOption , true),
            (NSPersistentStoreUbiquitousContentNameKey, "GameData"))
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        //iCloud notification subscriptions
        let notificationCenter = NSNotificationCenter.defaultCenter();
        
        notificationCenter.addObserver(
            self,
            selector: "persistentStoreCoordinatorStoresWillChange:",
            name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
            object: coordinator)
        
        notificationCenter.addObserver(self,
            selector: "persistentStoreCoordinatorStoresDidChange:",
            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
            object: coordinator)
        
        notificationCenter.addObserver(self,
            selector: "persistentStoreDidImportUbiquitousContentChanges:",
            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: coordinator)
        
        notificationCenter.addObserver(self,
            selector: "managedObjectContextDidSave:",
            name: NSManagedObjectContextDidSaveNotification,
            object: coordinator)
        
        return coordinator
    }()
    
    func persistentStoreCoordinatorStoresWillChange(notification: NSNotification) {
        print("persistentStoreCoordinatorStoresWillChange")
    }
    
    func persistentStoreCoordinatorStoresDidChange(notification: NSNotification) {
        print("persistentStoreCoordinatorStoresDidChange")
    }
    
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
        print("persistentStoreDidImportUbiquitousContentChanges")
    }
    
    func managedObjectContextDidSave(notification: NSNotification) {
        print("managedObjectContextDidSave")
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
