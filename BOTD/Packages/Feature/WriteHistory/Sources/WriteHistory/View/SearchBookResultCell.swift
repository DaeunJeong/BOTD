//
//  SearchBookResultCell.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import UIKit
import Kingfisher

public protocol SearchBookResultDisplayable {
    var id: String { get }
    var title: String { get }
    var author: String { get }
    var publisher: String { get }
    var description: String { get }
    var coverImageURL: URL? { get }
}

public final class SearchBookResultCell: UICollectionViewCell, SearchBookCellProtocol {
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .medium), textColor: .black)
    private let authorLabel = UILabel(font: .systemFont(ofSize: 14, weight: .regular), textColor: .gray600)
    private let publisherLabel = UILabel(font: .systemFont(ofSize: 14, weight: .regular), textColor: .gray600)
    private let descriptionLabel = UILabel(font: .systemFont(ofSize: 12, weight: .regular), textColor: .gray600)
    private let borderView = UIView(backgroundColor: .gray400)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(coverImageView, titleLabel, authorLabel, publisherLabel, descriptionLabel, borderView)
        
        setupConstraints()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 6
        coverImageView.layer.borderColor = UIColor.gray400.cgColor
        coverImageView.layer.borderWidth = 1
        coverImageView.clipsToBounds = true
        descriptionLabel.numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: SearchBookCelData) {
        guard case let .result(book) = cellData else { return }
        coverImageView.kf.setImage(with: book.coverImageURL)
        titleLabel.text = book.title
        authorLabel.text = "지은이: " + book.author
        publisherLabel.text = "출판사: " + book.publisher
        descriptionLabel.text = book.description
    }
    
    private func setupConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(90)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(coverImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(authorLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
        }
        borderView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
