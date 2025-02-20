//
//  LibraryAddBookCell.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import UIKit

public final class LibraryAddBookCell: UICollectionViewCell, LibraryCellProtocol {
    private let addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))?
            .withTintColor(.gray600, renderingMode: .alwaysOriginal)
        let button = UIButton(configuration: config)
        button.backgroundColor = .beige300
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    public var addButtonTappedHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = .init(width: 0, height: 10)
        contentView.layer.shadowRadius = 6
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        
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
