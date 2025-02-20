//
//  LibraryTitleHeaderCell.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import UIKit
import Extension

public final class LibraryTitleHeaderCell: UICollectionViewCell, LibraryCellProtocol {
    private let titleLabel = UILabel(font: .boldSystemFont(ofSize: 24), textColor: .black)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
        titleLabel.numberOfLines = 0
        
        let titleText = "오늘 읽은 책을 기록했나요?📚\n지금까지 기록한 책들을 둘러보세요."
        let attributedString = NSMutableAttributedString(string: titleText)
        attributedString.addAttributes(font: .boldSystemFont(ofSize: 20), color: nil, pointText: "지금까지 기록한 책들을 둘러보세요.")
        attributedString.addAttributes(font: nil, color: .beige700, pointText: "책")
        titleLabel.attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: LibraryCellData) {    }
}
