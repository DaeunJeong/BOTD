//
//  HomeCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 1/24/25.
//

import UIKit
import HistoryDetail
import Home
import WriteHistory

final class HomeCoordinator: HomeCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func presentWriteHistoryVC(defaultDate: Date) {
        let writeHistoryNC = UINavigationController()
        let writeHistoryRP = WriteHistoryRepository()
        let writeHistoryVM = WriteHistoryViewModel(repository: writeHistoryRP, defaultDate: defaultDate)
        let writeHistoryCD = WriteHistoryCoordinator(nav: writeHistoryNC)
        let writeHistoryVC = WriteHistoryViewController(coordinator: writeHistoryCD, viewModel: writeHistoryVM)
        writeHistoryNC.viewControllers = [writeHistoryVC]
        writeHistoryNC.modalPresentationStyle = .fullScreen
        nav?.present(writeHistoryNC, animated: true)
    }
    
    func presentHistoryDetailVC(historyOfDateID: String) {
        let nc = UINavigationController()
        let rp = HistoryDetailRepository()
        let vm = HistoryDetailViewModel(repository: rp)
        let vc = HistoryDetailViewController(viewModel: vm)
        nc.viewControllers = [vc]
        nc.modalPresentationStyle = .fullScreen
        nav?.present(nc, animated: true)
    }
}
