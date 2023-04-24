//
//  Thread+Extension.swift
//  
//
//  Created by Duc Do on 24.4.2023.
//

import Foundation

/// Executing task on main thread
public func runOnMainThread(task: @escaping () -> Void) {
    if Thread.isMainThread {
        task()
    } else {
        DispatchQueue.main.async(execute: task)
    }
}
