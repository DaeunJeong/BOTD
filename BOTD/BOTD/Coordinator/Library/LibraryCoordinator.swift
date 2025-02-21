//
//  LibraryCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 2/21/25.
//

import UIKit
import HistoryDetail
import Library
import WriteHistory

public final class LibraryCoordinator: LibraryCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    public func presentWriteHistoryVC() {
        let writeHistoryNC = UINavigationController()
        let writeHistoryRP = WriteHistoryRepository()
        let writeHistoryVM = WriteHistoryViewModel(repository: writeHistoryRP)
        let writeHistoryCD = WriteHistoryCoordinator(nav: writeHistoryNC)
        let writeHistoryVC = WriteHistoryViewController(coordinator: writeHistoryCD, viewModel: writeHistoryVM)
        writeHistoryNC.viewControllers = [writeHistoryVC]
        writeHistoryNC.modalPresentationStyle = .fullScreen
        nav?.present(writeHistoryNC, animated: true)
    }
    
    public func presentHistoryDetailVC(bookID: String) {
        let nc = UINavigationController()
        let rp = HistoryDetailRepository()
        let vm = HistoryDetailViewModel(repository: rp, filter: .book(bookID: bookID))
        let vc = HistoryDetailViewController(viewModel: vm)
        nc.viewControllers = [vc]
        nc.modalPresentationStyle = .fullScreen
        nav?.present(nc, animated: true)
    }
}
