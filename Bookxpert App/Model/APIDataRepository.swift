//
//  APIDataRepository.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import Foundation
import CoreData
import UIKit

class APIDataRepository {
    static let shared = APIDataRepository()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: Save API Items
    func saveObjects(_ apiObjects: [APIItem]) {
        for object in apiObjects {
            // Prevent duplicate save by checking ID
            if !objectExists(id: object.id ?? "") {
                let entity = ItemEntity(context: context)
                entity.id = object.id
                entity.name = object.name
                entity.data = try? JSONEncoder().encode(object.data)
            }
        }
        saveContext()
    }

    // MARK: Fetch All Stored Items
    func fetchStoredObjects() -> [APIItem] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                let decodedData = (try? JSONDecoder().decode([String: CodableValue].self, from: entity.data ?? Data())) ?? [:]
                return APIItem(id: entity.id, name: entity.name, data: decodedData)
            }
        } catch {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: Update Name of Item by ID
    func updateObject(id: String, newName: String) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let result = try context.fetch(request).first {
                result.name = newName
                saveContext()
            }
        } catch {
            print("Update error: \(error.localizedDescription)")
        }
    }

    // MARK: Delete Object by ID
    func deleteObject(id: String) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
                saveContext()
            }
        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }

    // MARK: Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed saving context: \(error.localizedDescription)")
        }
    }

    // MARK: Check if Object Exists
    private func objectExists(id: String) -> Bool {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
}
