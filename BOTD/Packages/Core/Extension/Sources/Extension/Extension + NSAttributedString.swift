//
//  Extension + NSAttributedString.swift
//  Extension
//
//  Created by 정다은 on 1/10/25.
//

import UIKit

public extension NSMutableAttributedString {
    func addAttributes(font: UIFont?, color: UIColor?, pointText: String) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attrs[.font] = font
        }
        if let color = color {
            attrs[.foregroundColor] = color
        }
        addAttributes(attrs, range: NSString(string: string).range(of: pointText))
    }
}
