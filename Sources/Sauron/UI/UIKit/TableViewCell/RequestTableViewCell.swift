//
//  RequestTableViewCell.swift
//  whim-ios
//
//  Created by Do Duc on 04/03/2019.
//  Copyright © 2019 maas. All rights reserved.
//

import UIKit

final class RequestTableViewCell: UITableViewCell {

    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var requestContentLabel: UILabel!

    func config(request: RequestModel, highlighted keyword: String? = nil) {
        configStatus(request)

        configContent(request, keyword)
    }

    private func configStatus(_ request: RequestModel) {
        var text = Sauron.shared.dateFormatter.string(from: request.date) + "\n"

        if request.code == 0 {
            text += "⬆️ ..."            
        } else {
            text += "\(request.code.statusIcon) \(request.code)"
        }

        statusLabel.text = text
    }

    private func configContent(_ request: RequestModel, _ keyword: String?) {
        var durationText = ""
        if let duration = request.duration {
            durationText = String(format: "[⏱ %.1fs] ", duration)
        }
        let requestText = "\(request.method) \(durationText)\(request.url)"

        requestContentLabel.attributedText = NSAttributedString(fullText: requestText, highlightedText: keyword)
    }
}
