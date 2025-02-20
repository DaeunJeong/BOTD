//
//  LibraryBookCell.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import UIKit
import Kingfisher

public final class LibraryBookCell: UICollectionViewCell, LibraryCellProtocol {
    private let bookImageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bookImageView)
        bookImageView.layer.cornerRadius = 6
        bookImageView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = .init(width: 0, height: 10)
        contentView.layer.shadowRadius = 6
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        
        bookImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: LibraryCellData) {
        guard case let .book(_, imageURL) = cellData else { return }
        bookImageView.kf.setImage(with: imageURL)
    }
}
