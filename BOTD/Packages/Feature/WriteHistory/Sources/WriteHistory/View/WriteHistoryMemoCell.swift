//
//  WriteHistoryMemoCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/4/25.
//

import UIKit
import CommonUI

public final class WriteHistoryMemoCell: MemoCell, WriteHistoryCellProtocol, EditHistoryCellProtocol {
    private let deleteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))?
            .withTintColor(.brown400, renderingMode: .alwaysOriginal)
        config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let button = UIButton(configuration: config)
        return button
    }()
    
    public var deleteButtonTappedHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(-8)
            make.trailing.equalTo(containerView.snp.trailing).offset(8)
        }
        
        deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapDeleteButton() {
        deleteButtonTappedHandler?()
    }
    
    public func apply(cellData: WriteHistoryCellData) {
        if case let .passage(text) = cellData {
            apply(text: text)
        } else if case let .memo(text) = cellData {
            apply(text: text)
        }
    }
    
    public func apply(cellData: EditHistoryCellData) {
        if case let .passage(text) = cellData {
            apply(text: text)
        } else if case let .memo(text) = cellData {
            apply(text: text)
        }
    }
}
