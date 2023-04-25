//
//  NSAttributedString+Extensions.swift
//  
//
//  Created by Duc Do on 24.4.2023.
//

import UIKit

public extension NSAttributedString {
    convenience init(
        fullText: String,
        regularFont: UIFont = UIFont.systemFont(ofSize: 14),
        regularTextColor: UIColor = .white,
        highlightedText: String?,
        highlightedTextFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold),
        highlightedTextColor: UIColor = UIColor.systemYellow,
        paragraphStyle: NSParagraphStyle? = nil
    ) {
        
        var regularAttributes: [NSAttributedString.Key: Any] = [
            .font: regularFont,
            .foregroundColor: regularTextColor
        ]
        var highlightedAttributes: [NSAttributedString.Key: Any] = [
            .font: highlightedTextFont,
            .foregroundColor: highlightedTextColor
        ]

        if let paragraphStyle = paragraphStyle {
            regularAttributes[.paragraphStyle] = paragraphStyle
            highlightedAttributes[.paragraphStyle] = paragraphStyle
        }

        let attr = NSMutableAttributedString(
            string: fullText,
            attributes: regularAttributes
        )

        if let keyword = highlightedText {
            var searchRange = NSRange(location: 0, length: fullText.count)
            var foundRange = NSRange()

            while searchRange.location < fullText.count {
                searchRange.length = fullText.count - searchRange.location
                foundRange = (fullText as NSString).range(of: keyword, options: NSString.CompareOptions.caseInsensitive, range: searchRange)

                if foundRange.location != NSNotFound {
                    searchRange.location = foundRange.location + foundRange.length
                    attr.addAttributes(highlightedAttributes, range: foundRange)
                } else {
                    break
                }
            }
        }

        self.init(attributedString: attr)
    }
}
