//
//  APIService.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    func fetchObjects(completion: @escaping (Result<[APIItem], Error>) -> Void) {
        guard let url = URL(string: "https://api.restful-api.dev/objects") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Empty response", code: 204)))
                return
            }

            do {
                let objects = try JSONDecoder().decode([APIItem].self, from: data)
                completion(.success(objects))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

