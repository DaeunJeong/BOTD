//
//  HomeTodaysPassageCell.swift
//  Home
//
//  Created by 정다은 on 1/13/25.
//

import UIKit

public class HomeTodaysPassageCell: UICollectionViewCell, HomeCellProtocol {
    private let containerView = UIView(backgroundColor: .white)
    private let topMarksLabel = UILabel(font: .systemFont(ofSize: 24, weight: .semibold), textColor: .black, text: "“")
    private let passageLabel = UILabel(font: .systemFont(ofSize: 16, weight: .medium), textColor: .black)
    private let bottomMarksLabel = UILabel(font: .systemFont(ofSize: 24, weight: .semibold), textColor: .black, text: "”")
    private let detailButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "자세히"
        config.attributedTitle = .init("자세히", font: .systemFont(ofSize: 12, weight: .semibold), color: .black)
        config.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 8))
        config.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.imagePlacement = .trailing
        let button = UIButton(configuration: config)
        button.tintColor = .black
        return button
    }()
    public var detailButtonTappedHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubviews(topMarksLabel, passageLabel, bottomMarksLabel, detailButton)
        passageLabel.numberOfLines = 6
        passageLabel.textAlignment = .center
        
        containerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
            make.trailing.bottom.equalToSuperview().offset(-24)
        }
        topMarksLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
        }
        passageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        bottomMarksLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-16)
        }
        detailButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
        
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.gray400.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .init(width: 0, height: 10)
        containerView.layer.shadowRadius = 6
        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        detailButton.addTarget(self, action: #selector(tapDetailButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapDetailButton() {
        detailButtonTappedHandler?()
    }
    
    public func apply(cellData: HomeCellData) {
        guard case let .todaysPassage(passage, historyID) = cellData else { return }
        passageLabel.text = passage
        detailButton.isHidden = historyID == nil
    }
}
