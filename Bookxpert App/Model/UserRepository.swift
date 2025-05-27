//
//  UserRepository.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import Foundation
import CoreData
import UIKit

class UserRepository {

    // Singleton instance
    static let shared = UserRepository()

    private let context: NSManagedObjectContext

    private init() {
        // Get the AppDelegate's Core Data context safely
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get AppDelegate")
        }
        context = appDelegate.persistentContainer.viewContext
    }

    func saveUser(name: String, email: String) {
        deleteAllUsers()  // Ensure only one user is stored

        let user = User(context: context)
        user.id = UUID()
        user.name = name
        user.email = email

        do {
            try context.save()
            print("User saved to Core Data")
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }

    func getUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(request)
            return users.first
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteAllUsers() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete users: \(error.localizedDescription)")
        }
    }
}
