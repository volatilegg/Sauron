//
//  Atomic.swift
//  Sauron
//
//  Created by Dima Osadchy on 21.10.2019.
//

import Foundation

final class Atomic<A> {
    private let queue = DispatchQueue(label: "Atomic Serial Queue")
    private var _value: A
    
    init(_ value: A) {
        _value = value
    }
    
    /// Get your Value, if you want to mutate it, use mutate method
    var value: A {
        get {
            return queue.sync{ self._value }
        }
    }
    
    /// Mutate your value
    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
