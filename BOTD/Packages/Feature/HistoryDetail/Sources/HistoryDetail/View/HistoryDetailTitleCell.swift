//
//  HistoryDetailTitleCell.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/18/25.
//

import UIKit
import Extension

public final class HistoryDetailTitleCell: UICollectionViewCell, HistoryDetailCellProtocol {
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
    
    public func apply(cellData: HistoryDetailCellData) {
        guard case let .title(title) = cellData else { return }
        titleLabel.text = title
    }
}

