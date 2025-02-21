//
//  MainTabBarController.swift
//  BOTD
//
//  Created by 정다은 on 1/7/25.
//

import UIKit
import Home
import Library

class MainTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeTab = UITab(title: "홈", image: UIImage(systemName: "house"), identifier: "Home") { _ in
            let homeRP = HomeRepository()
            let homeVM = HomeViewModel(repository: homeRP)
            let homeNC = UINavigationController()
            let homeCD = HomeCoordinator(nav: homeNC)
            let homeVC = HomeViewController(coordinator: homeCD, viewModel: homeVM)
            homeNC.viewControllers = [homeVC]
            return homeNC
        }
        let libraryTab = UITab(title: "서재", image: UIImage(systemName: "books.vertical.fill"), identifier: "Library") { _ in
            let libraryNC = UINavigationController()
            let libraryRP = LibraryRepository()
            let libraryVM = LibraryViewModel(repository: libraryRP)
            let libraryCD = LibraryCoordinator(nav: libraryNC)
            let libraryVC = LibraryViewController(coordinator: libraryCD, viewModel: libraryVM)
            libraryNC.viewControllers = [libraryVC]
            return libraryNC
        }
        tabs = [homeTab, libraryTab]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
