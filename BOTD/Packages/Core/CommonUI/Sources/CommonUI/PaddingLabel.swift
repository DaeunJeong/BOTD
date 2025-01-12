//
//  PaddingLabel.swift
//  CommonUI
//
//  Created by 정다은 on 1/12/25.
//

import UIKit

public class PaddingLabel: UILabel {
    public var padding: UIEdgeInsets = .zero

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
