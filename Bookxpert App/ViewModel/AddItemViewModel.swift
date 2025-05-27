//
//  AddItemViewModel.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 28/05/25.
//

import Foundation

class AddItemViewModel {
    func save(item: APIItem) {
        APIDataRepository.shared.saveObjects([item])
    }
}
