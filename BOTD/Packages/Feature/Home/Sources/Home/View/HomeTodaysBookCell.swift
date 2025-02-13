//
//  HomeTodaysBookCell.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import UIKit

public class HomeTodaysBookCell: UICollectionViewCell, HomeCellProtocol {
    private let bookView = BookView()
    private let addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))
        let button = UIButton(configuration: config)
        button.backgroundColor = .beige500
        button.tintColor = .brown800
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    public var bookViewTappedHandler: (() -> Void)?
    public var addButtonTappedHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(bookView, addButton)
        bookView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(bookView.snp.trailing).offset(8)
            make.bottom.equalTo(bookView.snp.bottom)
            make.width.height.equalTo(24)
        }
        
        let tapBookViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapBookView))
        bookView.addGestureRecognizer(tapBookViewGesture)
        addButton.isHidden = true
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
    }
    
    @objc private func tapBookView() {
        bookViewTappedHandler?()
    }
    
    @objc private func tapAddButton() {
        addButtonTappedHandler?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HomeCellData) {
        guard case let .todaysBook(historyOfDateID, bookImageURL) = cellData else { return }
        
        if historyOfDateID != nil, let bookImageURL = bookImageURL {
            bookView.apply(imageURL: bookImageURL)
            addButton.isHidden = false
        } else {
            bookView.apply(imageURL: nil)
            addButton.isHidden = true
        }
    }
}
