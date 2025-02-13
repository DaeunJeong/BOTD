//
//  HistoryDetailViewController.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/13/25.
//

import UIKit

public final class HistoryDetailViewController: UIViewController {
    public init(viewModel: HistoryDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: HistoryDetailViewModelProtocol
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal),
                                                 style: .plain, target: self, action: #selector(tapCloseButton))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    @objc private func tapCloseButton() {
        navigationController?.dismiss(animated: true)
    }
}
