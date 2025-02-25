//
//  HomeCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 1/24/25.
//

import UIKit
import EventBus
import HistoryDetail
import Home
import WriteHistory

final class HomeCoordinator: HomeCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    @MainActor func presentWriteHistoryVC(defaultDate: Date) {
        let writeHistoryNC = UINavigationController()
        let writeHistoryRP = WriteHistoryRepository()
        let writeHistoryVM = WriteHistoryViewModel(repository: writeHistoryRP, defaultDate: defaultDate,
                                                   eventBus: EventBus.shared)
        let writeHistoryCD = WriteHistoryCoordinator(nav: writeHistoryNC)
        let writeHistoryVC = WriteHistoryViewController(coordinator: writeHistoryCD, viewModel: writeHistoryVM)
        writeHistoryNC.viewControllers = [writeHistoryVC]
        writeHistoryNC.modalPresentationStyle = .fullScreen
        nav?.present(writeHistoryNC, animated: true)
    }
    
    func presentHistoryDetailVC(historyOfDateID: String, defaultCurrentHistoryID: String?) {
        let nc = UINavigationController()
        let rp = HistoryDetailRepository()
        let vm = HistoryDetailViewModel(repository: rp, filter: .date(historyOfDateID: historyOfDateID),
                                        defaultCurrentHistoryID: defaultCurrentHistoryID)
        let cd = HistoryDetailCoordinator(nav: nc)
        let vc = HistoryDetailViewController(coordinator: cd, viewModel: vm)
        nc.viewControllers = [vc]
        nc.modalPresentationStyle = .fullScreen
        nav?.present(nc, animated: true)
    }
}
