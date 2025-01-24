//
//  WriteHistoryViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 1/24/25.
//

import UIKit

public class WriteHistoryViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "기록 작성"
        view.backgroundColor = .white
    }
}
