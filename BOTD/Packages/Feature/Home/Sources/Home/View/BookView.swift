//
//  BookView.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import UIKit
import Kingfisher

class BookView: UIView {
    private let imageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(imageView)
        snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(160)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowRadius = 6
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(imageURL: URL?) {
        if let imageURL = imageURL {
            imageView.kf.setImage(with: imageURL)
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
            imageView.tintColor = .gray600
            imageView.backgroundColor = .beige300
            imageView.contentMode = .center
        }
    }
}
