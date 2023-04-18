//
//  ViewController.swift
//  Sauron
//
//  Created by volatilegg on 04/18/2023.
//  Copyright (c) 2023 volatilegg. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestNetwork()
    }

    private func requestNetwork() {
        NetworkManager.shared.fetchPokemon(id: 33) { result in
            switch result {
                case let .success(pokemon):
                    print(pokemon.name)
                case let .failure(error):
                    print(error.description)
            }
        }
    }
}
