//
//  APIDataViewModel.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import Foundation
import CoreData

class APIDataViewModel {

    var objects: [APIItem] = []
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchAndSaveObjects() {
        APIService.shared.fetchObjects { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apiObjects):
                    self?.objects = apiObjects
                    APIDataRepository.shared.saveObjects(apiObjects)
                    self?.onDataUpdate?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }

    func getStoredObjects() -> [APIItem] {
        return APIDataRepository.shared.fetchStoredObjects()
    }

    func updateObject(id: String, newName: String) {
        APIDataRepository.shared.updateObject(id: id, newName: newName)
        onDataUpdate?()
    }

    func deleteObject(id: String) {
        APIDataRepository.shared.deleteObject(id: id)
        onDataUpdate?()
    }
}


