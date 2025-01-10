//
//  HomeTodaysBookCell.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import UIKit

public protocol TodaysBookDisplayable {
    var historyID: String { get }
    var bookImageURL: URL? { get }
}

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
        addButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HomeCellData) {
        guard case let .todaysBook(bookData) = cellData else { return }
        
        if let bookData = bookData {
            bookView.apply(imageURL: bookData.bookImageURL)
            addButton.isHidden = false
        } else {
            bookView.apply(imageURL: nil)
            addButton.isHidden = true
        }
    }
}
