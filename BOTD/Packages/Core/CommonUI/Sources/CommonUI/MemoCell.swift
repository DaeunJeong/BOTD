//
//  MemoCell.swift
//  CommonUI
//
//  Created by 정다은 on 2/18/25.
//

import UIKit
import SnapKit
import Extension

open class MemoCell: UICollectionViewCell {
    public let containerView = UIView(backgroundColor: .white)
    private let topMarksLabel = UILabel(font: .systemFont(ofSize: 16, weight: .semibold), textColor: .black, text: "“")
    private let textLabel = UILabel(font: .systemFont(ofSize: 12, weight: .medium), textColor: .black)
    private let bottomMarksLabel = UILabel(font: .systemFont(ofSize: 16, weight: .semibold), textColor: .black, text: "”")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubviews(topMarksLabel, textLabel, bottomMarksLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        topMarksLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        bottomMarksLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-12)
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
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 6
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(text: String) {
        textLabel.text = text
    }
}

