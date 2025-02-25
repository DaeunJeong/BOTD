//
//  HistoryDetailCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 2/25/25.
//

import UIKit
import WriteHistory
import HistoryDetail

public final class HistoryDetailCoordinator: HistoryDetailCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    public init(nav: UINavigationController?) {
        self.nav = nav
    }
    
    public func presentEditHistoryVC(historyID: String) {
        let nc = UINavigationController()
        let cd = EditHistoryCoordinator(nav: nc)
        let rp = EditHistoryRepository()
        let vm = EditHistoryViewModel(repository: rp, historyID: historyID)
        let vc = EditHistoryViewController(coordinator: cd, viewModel: vm)
        nc.modalPresentationStyle = .fullScreen
        nc.viewControllers = [vc]
        nav?.present(nc, animated: true)
    }
}
