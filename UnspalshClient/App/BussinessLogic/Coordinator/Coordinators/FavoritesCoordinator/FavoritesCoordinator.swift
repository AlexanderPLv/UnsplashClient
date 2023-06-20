//
//  FavoritesCoordinator.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

protocol FavoritesCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}

final class FavoritesCoordinator: BaseCoordinator, FavoritesCoordinatorOutput, TabBarItem {
    
    var flowNavigationController: UIViewController {
        router.toPresent!
    }
    
    var finishFlow: CompletionBlock?
    
    private let router: Routable
    private let factory: FavoritesBuilderProtocol

    init(
        router: Routable,
        factory: FavoritesBuilderProtocol
    ) {
        self.router = router
        self.factory = factory
        super.init()
    }
}

extension FavoritesCoordinator: Coordinator {
    func start() {
        performFlow()
    }
}

private extension FavoritesCoordinator {

    func performFlow() {
        let view = factory.buildFavoritesScreen()
        view.onDetailScreen = { [weak self] details in
            self?.runDetailsScreen(details: details)
        }
        router.setRootModule(view, hideBar: true)
    }
    
    func runDetailsScreen(details: ImageInfo) {
        let view = factory.buildDetailsScreen(imageInfo: details)
        view.showError = { [weak self] error in
            self?.showErrorAlert(error)
        }
        view.close = router.popModule
        router.push(view)
    }
    
    func showErrorAlert(_ error: String) {
        let view = factory.buildErrorAlert(message: error, completionHandler: dismiss)
        router.present(view)
    }
    
    func dismiss() {
        router.dismissModule()
    }
}
