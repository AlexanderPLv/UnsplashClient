//
//  TabBarCoordinator.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

protocol TabBarCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}

protocol TabBarItem {
    var flowNavigationController: UIViewController { get }
}
 
final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    private var window: UIWindow
    private let modulesFactory: TabBarBuilderProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: TabBarRouter
    
    init(
        window: UIWindow,
        router: TabBarRouter,
        factory: TabBarBuilderProtocol,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) {
        self.window = window
        self.router = router
        self.modulesFactory = factory
        self.coordinatorFactory = coordinatorFactory
        super.init()
    }
}

extension TabBarCoordinator: Coordinator {
    func start() {
        performFlow()
    }
}

private extension TabBarCoordinator {
    func performFlow() {
        guard let module = router.toPresent else { return }
        
        let collectionCoordinator = coordinatorFactory.makeCollectionCoordinator()
        addDependency(collectionCoordinator)
        collectionCoordinator.start()
        let favoritesCoordinator = coordinatorFactory.makeFavoritesCoordinator()
        addDependency(favoritesCoordinator)
        favoritesCoordinator.start()
        
        module.viewControllers = [
            collectionCoordinator.flowNavigationController,
            favoritesCoordinator.flowNavigationController
        ]
        
        router.setTabBarAsRoot(to: window)
    }
}
