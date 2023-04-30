//
//  CoreDataManager.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 20.03.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Singleton -
    
    static var shared = CoreDataManager()
    
    // MARK: - Initialization -
    
    private init() {}
    
    // MARK: - Core Data Stack -
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    func entityDescription(entityName: String) -> NSEntityDescription? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return nil }
        return entityDescription
    }
    
    func fetchResultController(entityName: String, sortBy: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor1 = NSSortDescriptor(key: "department", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: sortBy, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: "department", cacheName: nil)
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        return fetchedResultController
    }
    
    func fetchForSections() -> NSFetchedResultsController<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let sortDescriptor = NSSortDescriptor(key: "department", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: "department", cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            print(try fetchedResultsController.performFetch())
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        return fetchedResultsController
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving -
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
