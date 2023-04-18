//
//  ContentView.swift
//  SPMExample
//
//  Created by Duc Do on 18.4.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonName: String = "Nothing yet"

    var body: some View {
        VStack {
            Button("Touch this") {
                requestNetwork()
            }
            TextField("Title", text: $pokemonName)
        }
        .padding()
    }

    func requestNetwork() {
        NetworkManager.shared.fetchPokemon(id: 33) { result in
            switch result {
                case let .success(pokemon):
                    pokemonName = pokemon.name
                case let .failure(error):
                    print(error.description)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
