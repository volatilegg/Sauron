//
//  NetworkTableViewCell.swift
//  
//
//  Created by Duc Do on 25.4.2023.
//

import UIKit

class NetworkTableViewCell: UITableViewCell {

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
