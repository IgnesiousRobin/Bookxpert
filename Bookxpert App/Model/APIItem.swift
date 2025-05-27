//
//  APIItem.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import Foundation

struct APIItem: Codable {
    let id: String?
    var name: String?
    var data: [String: CodableValue]?
}

enum CodableValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)

    var stringValue: String {
        switch self {
        case .string(let s): return s
        case .int(let i): return "\(i)"
        case .double(let d): return "\(d)"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let i = try? container.decode(Int.self) {
            self = .int(i)
        } else if let d = try? container.decode(Double.self) {
            self = .double(d)
        } else if let s = try? container.decode(String.self) {
            self = .string(s)
        } else {
            throw DecodingError.typeMismatch(CodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid CodableValue"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let s): try container.encode(s)
        case .int(let i): try container.encode(i)
        case .double(let d): try container.encode(d)
        }
    }
}
