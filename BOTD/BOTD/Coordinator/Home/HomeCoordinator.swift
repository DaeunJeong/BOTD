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
        let writeHistoryVC = WriteHistoryViewController()
        let writeHistoryNC = UINavigationController(rootViewController: writeHistoryVC)
        nav?.present(writeHistoryNC, animated: true)
    }
}
