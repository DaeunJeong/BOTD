//
//  HomeLastWeekHistoryCell.swift
//  Home
//
//  Created by 정다은 on 1/12/25.
//

import UIKit
import CommonUI

public class HomeLastWeekHistoryCell: UICollectionViewCell, HomeCellProtocol {
    private let bookView = BookView()
    private let bookCountLabel: UILabel = {
        let label = PaddingLabel(font: .boldSystemFont(ofSize: 8), textColor: .white)
        label.padding = .init(top: 0, left: 4, bottom: 0, right: 4)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    private let dateLabel = UILabel(font: .boldSystemFont(ofSize: 12), textColor: .black)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(bookView, bookCountLabel, dateLabel)
        
        bookView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        bookCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bookView.snp.trailing).offset(-4)
            make.bottom.equalTo(bookView.snp.bottom).offset(-4)
            make.height.equalTo(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(bookView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HomeCellData) {
        guard case let .lastWeekHistory(_, mainBookImageURL, historyCount, date) = cellData else { return }
        if historyCount > 0 {
            bookView.apply(imageURL: mainBookImageURL)
            bookCountLabel.isHidden = historyCount <= 1
            bookCountLabel.text = "+\(historyCount - 1)"
        } else {
            bookView.apply(imageURL: nil)
            bookCountLabel.isHidden = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateLabel.text = dateFormatter.string(from: date)
    }
}
