//
//  HistoryDetailBorderCell.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/18/25.
//

import UIKit

public final class HistoryDetailBorderCell: UICollectionViewCell, HistoryDetailCellProtocol {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .gray400
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HistoryDetailCellData) {    }
}
