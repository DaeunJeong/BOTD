//
//  LibraryEmptyCell.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import UIKit

public final class LibraryEmptyCell: UICollectionViewCell, LibraryCellProtocol {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 14, weight: .medium), textColor: .black,
                                     text: "기록한 책이 없어요.\n오늘 읽은 책을 기록해 보세요.")
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
            make.center.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAddButton() {
        addButtonTappedHandler?()
    }
    
    public func apply(cellData: LibraryCellData) {    }
}
