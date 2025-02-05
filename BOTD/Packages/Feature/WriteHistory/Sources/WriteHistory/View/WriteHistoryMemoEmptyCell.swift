//
//  WriteHistoryMemoEmptyCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/4/25.
//

import UIKit

public final class WriteHistoryMemoEmptyCell: UICollectionViewCell, WriteHistoryCellProtocol {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 14, weight: .medium), textColor: .black)
    private let addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .brown400
        config.background.cornerRadius = 15
        config.attributedTitle = .init("작성", font: .boldSystemFont(ofSize: 14), color: .white)
        config.contentInsets = .init(top: 8, leading: 20, bottom: 8, trailing: 20)
        let button = UIButton(configuration: config)
        return button
    }()
    
    public var addButtonTappedHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(titleLabel, addButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
        
        titleLabel.textAlignment = .center
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAddButton() {
        addButtonTappedHandler?()
    }
    
    public func apply(cellData: WriteHistoryCellData) {
        if case .passageEmpty = cellData {
            titleLabel.text = "구절을 작성해 보세요✏️"
        } else if case .memoEmpty = cellData {
            titleLabel.text = "메모를 작성해 보세요✏️"
        }
    }
}
