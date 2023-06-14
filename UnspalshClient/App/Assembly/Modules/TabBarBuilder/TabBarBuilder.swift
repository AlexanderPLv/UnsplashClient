//
//  TabBarBuilder.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

protocol TabBarBuilderProtocol {
    func buildTabBarController() -> TabBarViewController
}

extension ModulesFactory: TabBarBuilderProtocol {
    func buildTabBarController() -> TabBarViewController {
        let controller = TabBarViewController()
        return controller
    }
}
