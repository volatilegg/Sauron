//
//  RequestDetailsViewController.swift
//  whim-ios
//
//  Created by Do Duc on 04/03/2019.
//  Copyright © 2019 maas. All rights reserved.
//

import UIKit

final class RequestDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    //

    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var requestSegmentControl: UISegmentedControl!
    @IBOutlet private weak var statusCatImageView: UIImageView!

    // MARK: - Dependencies
    // var dependencyName: DependencyType!
    //
    var request: RequestModel!

    // MARK: - LifeCycle Methods
    // loadView > viewDidLoad > viewWillAppear > viewWillLayoutSubviews > viewDidLayoutSubviews > viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        showRequest()
    }

    // MARK: - Route Methods
    // @IBActions, prepare(...), ...

    @IBAction func backButtonTapped(_ sender: Any) {
        abort(animated: true)
    }


    @IBAction func shareButtonTapped(_ sender: Any) {

        // Due to slack only shares the first element of the array, the element in items array will be converted into one string
        // with line break
        let requestString = request.code.addHttp() + "\n" + request.requestString.addQuoteToSlack() + "\n" + request.responseString.addQuoteToSlack()
        let items = [requestString]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true)
//        show(activityViewController, sender: nil)
    }

    @IBAction func requestSegmentValueChanged(_ sender: Any) {
        switch requestSegmentControl.selectedSegmentIndex {
            case 0:
                showRequest()
            case 1:
                showResponse()
            default:
                break
        }
    }

    // MARK: - Private Methods
    //

    private func showRequest() {
        contentTextView.text = request.requestString
    }

    private func showResponse() {
        contentTextView.text = request.responseString
    }
}

extension String {
    func addQuoteToSlack() -> String {
        return "```" + self + "```"
    }
}

extension Int {
    func addHttp(_ isCat: Bool = true) -> String {
        let httpString = isCat ? "https://http.cat/" : "https://httpstatusdogs.com/"
        return httpString + "\(self)"
    }
}
