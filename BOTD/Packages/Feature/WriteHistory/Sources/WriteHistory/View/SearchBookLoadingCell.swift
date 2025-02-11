//
//  SearchBookLoadingCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/11/25.
//

import UIKit

public final class SearchBookLoadingCell: UICollectionViewCell, SearchBookCellProtocol {
    private let indicatorView = UIActivityIndicatorView(style: .medium)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints({ $0.center.equalToSuperview() })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: SearchBookCelData) {
        indicatorView.startAnimating()
    }
}
