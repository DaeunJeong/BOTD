//
//  WriteHistoryTitleHeaderCell.swift
//  WriteHistory
//
//  Created by 정다은 on 1/24/25.
//

import UIKit
import Extension

public final class WriteHistoryTitleHeaderCell: UICollectionViewCell, WriteHistoryCellProtocol, EditHistoryCellProtocol {
    private let titleLabel = UILabel(font: .boldSystemFont(ofSize: 16), textColor: .black)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: WriteHistoryCellData) {
        guard case let .titleHeader(title) = cellData else { return }
        titleLabel.text = title
    }
    
    public func apply(cellData: EditHistoryCellData) {
        guard case let .titleHeader(title) = cellData else { return }
        titleLabel.text = title
    }
}
