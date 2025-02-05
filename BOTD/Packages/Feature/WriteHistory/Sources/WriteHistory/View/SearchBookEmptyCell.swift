//
//  SearchBookEmptyCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import UIKit

public final class SearchBookEmptyCell: UICollectionViewCell, SearchBookCellProtocol {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 16, weight: .medium), textColor: .black)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: SearchBookCelData) {
        guard case let .empty(title) = cellData else { return }
        titleLabel.text = title
    }
}
