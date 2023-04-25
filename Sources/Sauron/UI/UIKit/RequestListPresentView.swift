//
//  RequestListPresentView.swift
//  
//
//  Created by Duc Do on 25.4.2023.
//

import SwiftUI

public struct RequestListPresentView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = RequestsListViewController

    public init() { }

    public func makeUIViewController(context: Context) -> RequestsListViewController {
        return RequestsListViewController(nibName: "RequestsListViewController", bundle: Bundle.module)
    }

    public func updateUIViewController(_ uiViewController: RequestsListViewController, context: Context) {

    }
}
