//
//  SearchBookViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import UIKit

public final class SearchBookViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal),
                                                 style: .plain, target: self, action: #selector(tapBackButton))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "책 검색"
        view.backgroundColor = .white
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
