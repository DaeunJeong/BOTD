//
//  EditHistoryCoordinator.swift
//  BOTD
//
//  Created by 정다은 on 2/25/25.
//

import UIKit
import Service
import WriteHistory

final class EditHistoryCoordinator: EditHistoryCoordinatorProtocol {
    private weak var nav: UINavigationController?
    
    init(nav: UINavigationController?) {
        self.nav = nav
    }
    
    func pushWriteMemoVC(title: String, completeHandler: @escaping (String) -> Void) {
        let vc = WriteMemoViewController(title: title, completeHandler: completeHandler)
        nav?.pushViewController(vc, animated: true)
    }
}
