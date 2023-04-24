//
//  RequestsListViewController.swift
//  whim-ios
//
//  Created by Do Duc on 04/03/2019.
//  Copyright © 2019 maas. All rights reserved.
//

import UIKit

final class RequestsListViewController: UIViewController {

    private enum Scope: String, CaseIterable {
        case all
        case success = "2xx"
        case redirection = "3xx"
        case clientErrors = "4xx"
        case serverErrors = "5xx"

        init(index: Int) {
            switch index {
            case 1: self = .success
            case 2: self = .redirection
            case 3: self = .clientErrors
            case 4: self = .serverErrors
            default: self = .all
            }
        }

        init(statusCode: Int) {
            switch statusCode {
            case 200...299: self = .success
            case 300...399: self = .redirection
            case 400...499: self = .clientErrors
            case 500...599: self = .serverErrors
            default: self = .all
            }
        }
    }

    // MARK: - IBOutlets
    //

    @IBOutlet weak var requestsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    // MARK: - Private Properties
    //
    private var requests: [RequestModel] = []

    private weak var requestObserver: NSObjectProtocol?

    private var filter: (scope: Scope, keyword: String) = (.all, "") {
        didSet { reloadRequestsData() }
    }

    // MARK: - LifeCycle Methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSegmentedControl()

        requestsTableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "RequestTableViewCell")
        reloadRequestsData()

        requestObserver = NotificationCenter.default.addObserver(forName: Sauron.newRequestNotification, object: nil, queue: nil, using: { _ in
            runOnMainThread { [weak self] in
                guard let self = self else { return }
                self.reloadRequestsData()
            }
        })
    }

    // MARK: - Route Methods
    // @IBActions, prepare(...), ...

    @IBAction func backButtonTapped(_ sender: Any) {
        self.abort(animated: true)
    }

    @IBAction func nukeButtonTapped(_ sender: Any) {
        Sauron.shared.resetData()
        reloadRequestsData()
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        filter.scope = Scope(index: sender.selectedSegmentIndex)
    }

    // MARK: - Private Methods
    //
    private func configureSegmentedControl() {
        for (index, scope) in Scope.allCases.enumerated() {
            segmentedControl.setTitle(scope.rawValue, forSegmentAt: index)
        }
    }

    private func reloadRequestsData() {
        requests = Sauron.shared.requestModels
            .filter { filter.scope == .all || filter.scope == Scope(statusCode: $0.code) }
            .filter { filter.keyword.isEmpty || $0.url.lowercased().contains(filter.keyword) }
            .sorted(by: { $0.date > $1.date })

        requestsTableView.reloadData()
    }
}

extension RequestsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        let requestDetailsViewController = RequestDetailsViewController.makeFromStoryboard(request: request)

        show(requestDetailsViewController, sender: nil)
    }
}

extension RequestsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell", for: indexPath) as? RequestTableViewCell else {
            return UITableViewCell()
        }

        cell.config(request: requests[indexPath.row], highlighted: filter.keyword)
        return cell
    }

}

extension RequestsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter.keyword = searchText.lowercased().trim()
    }
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
