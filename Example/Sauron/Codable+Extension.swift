//
//  Codable+Extension.swift
//  Sauron_Example
//
//  Created by Duc Do on 18.4.2023.
//  Copyright © 2023 volatilegg. All rights reserved.
//

import Foundation

public extension Decodable {
    static func skipRootKeyFrom(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else {
            return nil
        }

        do {
            let rawData = try decoder.decode([String: Self].self, from: data)
            return rawData.first?.value
        } catch {
            print(error)
            return nil
        }
    }

    static func from(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else {
            return nil
        }
        return from(data: data)
    }

    static func from(url urlString: String) -> Self? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return from(data: data)
    }

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    static func from(data: Data) -> Self? {
        do {
            return try decoder.decode(Self.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}

public extension Encodable {

    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    var jsonData: Data? {
        return try? Self.encoder.encode(self)
    }

    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }

    var object: [String: Any] {
        guard let data = jsonData else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] ?? [:]
    }
}
