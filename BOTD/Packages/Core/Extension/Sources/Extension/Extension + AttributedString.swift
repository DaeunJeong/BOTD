//
//  Extension + AttributedString.swift
//  Extension
//
//  Created by 정다은 on 1/13/25.
//

import UIKit

public extension AttributedString {
    init(_ string: String, font: UIFont, color: UIColor) {
        var attributes = AttributeContainer()
        attributes.font = font
        attributes.foregroundColor = color
        self.init(string, attributes: attributes)
    }
}
