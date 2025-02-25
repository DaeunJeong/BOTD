//
//  WriteHistoryAddMemoCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/4/25.
//

import UIKit

public final class WriteHistoryAddMemoCell: UICollectionViewCell, WriteHistoryCellProtocol, EditHistoryCellProtocol {
    private let addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))?
            .withTintColor(.brown800, renderingMode: .alwaysOriginal)
        config.background.backgroundColor = .beige300
        let button = UIButton(configuration: config)
        return button
    }()
    
    public var addButtonTappedHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        addButton.layer.cornerRadius = 8
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowOffset = .init(width: 0, height: 10)
        addButton.layer.shadowRadius = 6
        addButton.clipsToBounds = false
        addButton.layer.masksToBounds = false
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAddButton() {
        addButtonTappedHandler?()
    }
    
    public func apply(cellData: WriteHistoryCellData) {    }
    public func apply(cellData: EditHistoryCellData) {    }
}
