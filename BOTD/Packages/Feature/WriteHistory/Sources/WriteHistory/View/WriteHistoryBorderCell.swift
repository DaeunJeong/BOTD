//
//  WriteHistoryBorderCell.swift
//  WriteHistory
//
//  Created by 정다은 on 1/28/25.
//

import UIKit

public final class WriteHistoryBorderCell: UICollectionViewCell, WriteHistoryCellProtocol, EditHistoryCellProtocol {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .gray400
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: WriteHistoryCellData) {    }
    public func apply(cellData: EditHistoryCellData) {    }
}
