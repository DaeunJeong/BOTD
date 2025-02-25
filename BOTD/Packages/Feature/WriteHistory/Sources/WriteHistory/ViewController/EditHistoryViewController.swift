//
//  EditHistoryViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 2/25/25.
//

import UIKit

public class EditHistoryViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal),
                                                 style: .plain, target: self, action: #selector(tapCloseButton))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "기록 편집"
    }
    
    @objc private func tapCloseButton() {
        navigationController?.dismiss(animated: true)
    }
}
