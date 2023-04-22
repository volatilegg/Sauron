//
//  RequestListView.swift
//  
//
//  Created by Duc Do on 18.4.2023.
//

import SwiftUI

public struct RequestListView: View {
    @ObservedObject var model = Sauron.shared

    public init() {

    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(model.publishedRequests) { request in
                    Text(request.url)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TestView: View {
    var body: some View {
        List {
            Text("test")
        }
        .listStyle(.plain)
    }
}

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView()
    }
}
