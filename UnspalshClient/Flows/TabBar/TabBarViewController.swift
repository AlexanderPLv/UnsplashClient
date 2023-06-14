//
//  TabBarViewController.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarAppearance()
    }
}

private extension TabBarViewController {
    
    func setupTabBarAppearance() {
        tabBar.isTranslucent = false
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
    }
}
