//
//  Data+Logging.swift
//  
//
//  Created by Duc Do on 20.4.2023.
//

import Foundation

extension Data {
    var bodyString: String {
        if
            let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
            let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let string = String(data: pretty, encoding: String.Encoding.utf8) {
            return string
        }

        if let string = String(data: self, encoding: String.Encoding.utf8) {
            return string
        }

        return self.description
    }
}
