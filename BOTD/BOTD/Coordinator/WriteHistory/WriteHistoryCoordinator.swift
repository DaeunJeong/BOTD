//
//  WriteHistoryCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 2/5/25.
//

import UIKit
import Service
import WriteHistory

final class WriteHistoryCoordinator: WriteHistoryCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController?) {
        self.nav = nav
    }
    
    func pushSearchBookVC() {
        let rp = SearchBookRepository(service: AladinService())
        let vm = SearchBookViewModel(repository: rp)
        let vc = SearchBookViewController(viewModel: vm)
        nav?.pushViewController(vc, animated: true)
    }
}
