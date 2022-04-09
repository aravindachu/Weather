//
//  CoreDataManager.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import Foundation
import CoreData

class CoreDataManager {

    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()

    private init() {
        persistentContainer = NSPersistentContainer(name: "Weather")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to initialize core data \(error)")
            }
        }
    }

    func save() {
        do {
            try persistentContainer.viewContext.save()
        }
        catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save Location with \(error)")
        }
    }

    func getAllLocations() -> [LocationModel] {
        let fetchRequest: NSFetchRequest<LocationModel> = LocationModel.fetchRequest()

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            print("Failed to fetch Locations \(error)")
            return []
        }
    }

    func getLocation(by woeid: Int64) -> LocationModel?  {
        let fetchRequest: NSFetchRequest<LocationModel> = LocationModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "woeid == %d", woeid)
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        }
        catch {
            print("Failed to fetch Locations \(error)")
            return nil
        }
    }
}

