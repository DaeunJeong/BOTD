//
//  HomeDividerCell.swift
//  Home
//
//  Created by 정다은 on 1/12/25.
//

import UIKit

public class HomeDividerCell: UICollectionViewCell, HomeCellProtocol {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .gray400
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HomeCellData) {    }
}
