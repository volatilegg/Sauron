//
//  UIViewController+Extensions.swift
//  
//
//  Created by Duc Do on 24.4.2023.
//

import UIKit

extension UIViewController {
    func abort(animated: Bool, completionCallback: (() -> Void)? = nil) {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: animated, completion: completionCallback)
        } else {
            self.dismiss(animated: animated, completion: completionCallback)
        }
    }
}
