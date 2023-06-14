//
//  CoordinatorFactory.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeTabBarCoordinator(window: UIWindow, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator
    & TabBarCoordinatorOutput
    func makeFavoritesCoordinator() -> Coordinator
    & FavoritesCoordinatorOutput & TabBarItem
    func makeCollectionCoordinator() -> Coordinator & CollectionCoordinatorOutput & TabBarItem
}

final class CoordinatorFactory {
    private lazy var modulesFactory = ModulesFactory.shared
}
 
extension CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makeCollectionCoordinator() -> Coordinator
    & CollectionCoordinatorOutput & TabBarItem {
        let navController = UINavigationController()
        let router = Router.build(with: navController)
        return CollectionCoordinator(router: router, factory: modulesFactory)
    }
    
    func makeFavoritesCoordinator() -> Coordinator
    & FavoritesCoordinatorOutput & TabBarItem {
        let navigationController = UINavigationController()
        let router = Router.build(with: navigationController)
        return FavoritesCoordinator(router: router, factory: modulesFactory)
    }
    
    func makeTabBarCoordinator(
        window: UIWindow,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) -> Coordinator & TabBarCoordinatorOutput {
        let tabBar = modulesFactory.buildTabBarController()
        let router = TabBarRouter(rootController: tabBar)
        return TabBarCoordinator(
            window: window,
            router: router,
            factory: modulesFactory,
            coordinatorFactory: coordinatorFactory
        )
    }
    
}
