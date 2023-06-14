//
//  AuthResultSerializer.swift
//  DatingApp
//
//  Created by Alexander Pelevinov on 17.05.2022.
//

import Foundation

class DecodableSerializer<ModelType: Decodable> {
    func decode(_ data: Data) throws -> [ModelType] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let value = try decoder.decode([ModelType].self, from: data)
        return value
    }
}
