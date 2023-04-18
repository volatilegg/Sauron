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
        NavigationView {
            VStack {
                HStack {

                    NavigationLink(destination: Text("Aloo")) {
                        Text("Do Something")
                    }
                    .padding()
                    .background(Color.red)
                    .clipShape(Capsule())

                    Button("Request API") {
                        requestNetwork()
                    }
                    .padding()
                    .background(Color.green)
                    .clipShape(Capsule())
                }
                .padding()
                TextField("Title", text: $pokemonName).multilineTextAlignment(.center)
            }
        }
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
