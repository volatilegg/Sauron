//
//  RequestsListViewController.swift
//  whim-ios
//
//  Created by Do Duc on 04/03/2019.
//  Copyright © 2019 maas. All rights reserved.
//

import UIKit

final public class RequestsListViewController: UIViewController {

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
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureSegmentedControl()

        requestsTableView.register(UINib(nibName: "NetworkTableViewCell", bundle: Bundle.module), forCellReuseIdentifier: "NetworkTableViewCell")
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
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        let requestDetailsViewController = RequestDetailsViewController.makeFromStoryboard(request: request)

        show(requestDetailsViewController, sender: nil)
    }
}

extension RequestsListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkTableViewCell", for: indexPath) as? NetworkTableViewCell else {
            return UITableViewCell()
        }

        cell.config(request: requests[indexPath.row], highlighted: filter.keyword)
        return cell
    }
}

extension RequestsListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter.keyword = searchText.lowercased().trim()
    }
}
