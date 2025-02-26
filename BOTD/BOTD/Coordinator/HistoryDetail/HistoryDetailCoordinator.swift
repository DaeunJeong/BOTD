//
//  HistoryDetailCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 2/25/25.
//

import UIKit
import EventBus
import HistoryDetail
import WriteHistory

public final class HistoryDetailCoordinator: HistoryDetailCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    public init(nav: UINavigationController?) {
        self.nav = nav
    }
    
    @MainActor public func presentEditHistoryVC(historyID: String, completeToEditHandler: @escaping () -> Void,
                                                completeToDeleteHandler: @escaping () -> Void) {
        let nc = UINavigationController()
        let cd = EditHistoryCoordinator(nav: nc)
        let rp = EditHistoryRepository()
        let vm = EditHistoryViewModel(repository: rp, eventBus: EventBus.shared, historyID: historyID)
        let vc = EditHistoryViewController(coordinator: cd, viewModel: vm, completeToEditHandler: completeToEditHandler,
                                           completeToDeleteHandler: completeToDeleteHandler)
        nc.modalPresentationStyle = .fullScreen
        nc.viewControllers = [vc]
        nav?.present(nc, animated: true)
    }
}
