//
//  WriteHistoryCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 2/5/25.
//

import UIKit
import WriteHistory

final class WriteHistoryCoordinator: WriteHistoryCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController?) {
        self.nav = nav
    }
    
    func pushSearchBookVC() {
        let vm = SearchBookViewModel()
        let vc = SearchBookViewController(viewModel: vm)
        nav?.pushViewController(vc, animated: true)
    }
}
