//
//  Extension + UIView.swift
//  Extension
//
//  Created by 정다은 on 1/10/25.
//

import UIKit

public extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
}
