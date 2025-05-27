//
//  ProductListViewModel.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 28/05/25.
//

import Foundation

class ProductListViewModel {
    var items: [APIItem] = []

    func loadData() {
        items = APIDataRepository.shared.fetchStoredObjects()
    }

    func deleteItem(at index: Int) {
        if let id = items[index].id {
            APIDataRepository.shared.deleteObject(id: id)
            items.remove(at: index)
            NotificationHelper.triggerDeletionNotification(for: id)
        }
    }

    func updateItem(at index: Int, newName: String) {
        if let id = items[index].id {
            APIDataRepository.shared.updateObject(id: id, newName: newName)
            items[index].name = newName
        }
    }
}
