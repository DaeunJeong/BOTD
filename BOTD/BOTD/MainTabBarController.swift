//
//  MainTabBarController.swift
//  BOTD
//
//  Created by 정다은 on 1/7/25.
//

import UIKit
import Home

class MainTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeTab = UITab(title: "홈", image: UIImage(systemName: "house"), identifier: "Home") { _ in
            let homeRP = HomeRepository()
            let homeVM = HomeViewModel(repository: homeRP)
            let homeVC = HomeViewController(viewModel: homeVM)
            let homeNC = UINavigationController(rootViewController: homeVC)
            return homeNC
        }
        tabs = [homeTab]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
