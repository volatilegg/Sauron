//
//  SwiftUIView.swift
//  
//
//  Created by Duc Do on 18.4.2023.
//

import SwiftUI

struct RequestListView: View {
    var body: some View {
        NavigationView {
            TabView {
                TestView()
                    .tabItem {
                        Image(systemName: "person.3")
                    }
                TestView()
                    .tabItem {
                        Image(systemName: "person.2")
                    }
            }
            .navigationTitle("Test")
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
