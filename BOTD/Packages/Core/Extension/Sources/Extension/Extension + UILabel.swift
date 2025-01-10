//
//  Extension + UILabel.swift
//  Extension
//
//  Created by 정다은 on 1/10/25.
//

import UIKit

public extension UILabel {
    convenience init(font: UIFont, textColor: UIColor, text: String? = nil) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.text = text
    }
}
