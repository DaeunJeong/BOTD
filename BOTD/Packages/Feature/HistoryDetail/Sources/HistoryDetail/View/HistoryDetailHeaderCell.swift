//
//  HistoryDetailHeaderCell.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/18/25.
//

import UIKit

public final class HistoryDetailHeaderCell: UICollectionViewCell, HistoryDetailCellProtocol {
    private let previousButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let button = UIButton(configuration: config)
        return button
    }()
    private let titleLabel = UILabel(font: .boldSystemFont(ofSize: 16), textColor: .black)
    private let nextButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let button = UIButton(configuration: config)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(previousButton, titleLabel, nextButton)
        
        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(previousButton.snp.centerY)
            make.leading.greaterThanOrEqualTo(previousButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(nextButton.snp.leading).offset(-8)
        }
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: HistoryDetailCellData) {
        guard case let .header(title, isPreviousButtonHidden, isNextButtonHidden) = cellData else { return }
        titleLabel.text = title
        previousButton.isHidden = isPreviousButtonHidden
        nextButton.isHidden = isNextButtonHidden
    }
}
