//
//  StoryboardType.swift
//  
//
//  Created by Duc Do on 25.4.2023.
//

import UIKit

internal enum StoryboardScene {
    internal enum Sauron: StoryboardType {
        internal static let storyboardName = "Sauron"

        internal static let initialScene = InitialSceneType<RequestsListViewController>(storyboard: Sauron.self)

        internal static let requestDetailsViewController = SceneType<RequestDetailsViewController>(storyboard: Sauron.self, identifier: "RequestDetailsViewController")

        internal static let requestsListViewController = SceneType<RequestsListViewController>(storyboard: Sauron.self, identifier: "RequestsListViewController")
    }
}

internal protocol StoryboardType {
    static var storyboardName: String { get }
}

internal extension StoryboardType {
    static var storyboard: UIStoryboard {
        let name = self.storyboardName
        return UIStoryboard(name: name, bundle: BundleToken.bundle)
    }
}

internal struct SceneType<T: UIViewController> {
    internal let storyboard: StoryboardType.Type
    internal let identifier: String

    internal func instantiate() -> T {
        let identifier = self.identifier
        guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
        }
        return controller
    }

    @available(iOS 13.0, tvOS 13.0, *)
    internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
        return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
    }
}

internal struct InitialSceneType<T: UIViewController> {
    internal let storyboard: StoryboardType.Type

    internal func instantiate() -> T {
        guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
            fatalError("ViewController is not of the expected class \(T.self).")
        }
        return controller
    }

    @available(iOS 13.0, tvOS 13.0, *)
    internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
        guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
            fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
        }
        return controller
    }
}

private final class BundleToken {
    static let bundle: Bundle = {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: BundleToken.self)
#endif
    }()
}

// MARK: - RequestDetailsViewController - StoryboardDependencyInjection
extension RequestDetailsViewController {
    static func makeFromStoryboard(
        request: RequestModel
    ) -> RequestDetailsViewController {

        let viewController = StoryboardScene.Sauron.requestDetailsViewController.instantiate()
        viewController.setDependencies(
            request: request
        )
        return viewController
    }

    func setDependencies(
        request: RequestModel
    ) {
        self.request = request
    }
}

// MARK: - RequestsListViewController - StoryboardDependencyInjection
extension RequestsListViewController {
    static func makeFromStoryboard(
    ) -> RequestsListViewController {

        let viewController = StoryboardScene.Sauron.requestsListViewController.instantiate()
        viewController.setDependencies(
        )
        return viewController
    }

    func setDependencies(
    ) {
    }
}
