//
//  MainTabBarController.swift
//  BOTD
//
//  Created by 정다은 on 1/7/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeTab = UITab(title: "홈", image: UIImage(systemName: "house"), identifier: "Home") { _ in
            UIViewController()
        }
        tabs = [homeTab]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
