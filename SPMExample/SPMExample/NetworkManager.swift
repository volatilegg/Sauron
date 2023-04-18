//
//  NetworkManager.swift
//  Sauron_Example
//
//  Created by Duc Do on 18.4.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Sauron

enum NetworkError: Error {
    case general
    case otherError(Error)

    var description: String {
        switch self {
            case .general:
                return "General error"
            case .otherError(let error):
                return error.localizedDescription
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager(
        baseUrl: URL(string: "https://pokeapi.co/api/v2/pokemon")!,
        defaultSession: demoConfig
    )

    static var demoConfig: URLSession {
        let config = Reqres.defaultSessionConfiguration(additionalHeaders: ["Content-Type":"application/json; charset=UTF-8"])
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }

    var baseUrl: URL
    var defaultSession: URLSession

    private init (
        baseUrl: URL,
        defaultSession: URLSession
    ) {
        self.baseUrl = baseUrl
        self.defaultSession = defaultSession
    }

    func fetchPokemon(id: Int, completionHandler: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!

        let task = defaultSession.dataTask(
            with: url,
            completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error with fetching pokemon: \(error)")
                    completionHandler(.failure(.otherError(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    completionHandler(.failure(.general))
                    return
                }

                guard let data = data else {
                    print("Error no data")
                    completionHandler(.failure(.general))
                    return
                }

                guard let pokemon = Pokemon.from(data: data) else {
                    completionHandler(.failure(.general))
                    return
                }

                completionHandler(.success(pokemon))
            }
        )
        task.resume()
    }
}
