//
//  RequestListItemView.swift
//  
//
//  Created by Duc Do on 20.4.2023.
//

import SwiftUI

struct RequestListItemView: View {
    @State var request: RequestModel

    var body: some View {
        Text(request.url)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListItemView(
            request: .init(
                id: UUID().uuidString,
                url: "https://pokeapi.co/api/v2/pokemon",
                date: Date(),
                method: "POST",
                headers: ["Content-Type":"application/json; charset=UTF-8"],
                httpBody: nil,
                code: 212,
                responseHeaders: nil,
                dataResponse: nil,
                errorClientDescription: nil,
                duration: 21.342
            )
        )
    }
}
