//
//  HomeCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 1/24/25.
//

import UIKit
import Home
import WriteHistory

final class HomeCoordinator: HomeCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func presentWriteHistoryVC() {
        let writeHistoryVM = WriteHistoryViewModel()
        let writeHistoryVC = WriteHistoryViewController(viewModel: writeHistoryVM)
        let writeHistoryNC = UINavigationController(rootViewController: writeHistoryVC)
        writeHistoryNC.modalPresentationStyle = .fullScreen
        nav?.present(writeHistoryNC, animated: true)
    }
}
