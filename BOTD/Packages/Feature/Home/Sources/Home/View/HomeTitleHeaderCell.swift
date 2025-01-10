//
//  HomeTitleHeaderCell.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import UIKit
import SnapKit
import Extension

public final class HomeTitleHeaderCell: UICollectionViewCell, HomeCellProtocol {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HomeCellData) {
        guard case .todaysBookHeader = cellData else { return }
        let titleText = "오늘 읽은 책은 어땠나요?📚\n기억에 남는 구절을 기록해 보세요."
        let attributedString = NSMutableAttributedString(string: titleText)
        attributedString.addAttributes(font: .boldSystemFont(ofSize: 20), color: nil, pointText: "기억에 남는 구절을 기록해 보세요.")
        attributedString.addAttributes(font: nil, color: .beige700, pointText: "책")
        titleLabel.attributedText = attributedString
    }
}
