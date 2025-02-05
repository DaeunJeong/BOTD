//
//  WriteHistoryMemoCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/4/25.
//

import UIKit

public final class WriteHistoryMemoCell: UICollectionViewCell, WriteHistoryCellProtocol {
    private let containerView = UIView(backgroundColor: .white)
    private let topMarksLabel = UILabel(font: .systemFont(ofSize: 16, weight: .semibold), textColor: .black, text: "“")
    private let textLabel = UILabel(font: .systemFont(ofSize: 12, weight: .medium), textColor: .black)
    private let bottomMarksLabel = UILabel(font: .systemFont(ofSize: 16, weight: .semibold), textColor: .black, text: "”")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubviews(topMarksLabel, textLabel, bottomMarksLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topMarksLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        bottomMarksLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.gray400.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .init(width: 0, height: 10)
        containerView.layer.shadowRadius = 6
        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: WriteHistoryCellData) {
        if case let .passage(text) = cellData {
            textLabel.text = text
        } else if case let .memo(text) = cellData {
            textLabel.text = text
        }
    }
}
