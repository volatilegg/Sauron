//
//  String+Extensions.swift
//  
//
//  Created by Duc Do on 24.4.2023.
//

import Foundation

extension String {
    /// Trim all spaces and new line in the end of strings
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
