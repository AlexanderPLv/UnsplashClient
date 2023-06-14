//
//  CollectionCoordinator.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

protocol CollectionCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}

final class CollectionCoordinator: BaseCoordinator, CollectionCoordinatorOutput, TabBarItem {
    
    var flowNavigationController: UIViewController {
        router.toPresent!
    }
    
    var finishFlow: CompletionBlock?
    
    private let router: Routable
    private let factory: CollectionBuilderProtocol

    init(
        router: Routable,
        factory: CollectionBuilderProtocol
    ) {
        self.router = router
        self.factory = factory
        super.init()
    }
}

extension CollectionCoordinator: Coordinator {
    func start() {
        performFlow()
    }
}

private extension CollectionCoordinator {

    func performFlow() {
        let view = factory.buildCollectionScreen()
        view.onDetailScreen = { [weak self] details in
            self?.runDetailsScreen(details: details)
        }
        view.showError = { [weak self] error in
            self?.showErrorAlert(error)
        }
        router.setRootModule(view, hideBar: true)
    }
    
    func showErrorAlert(_ error: String) {
        let view = factory.buildErrorAlert(message: error, completionHandler: dismiss)
        router.present(view)
    }
    
    func runDetailsScreen(details: ImageInfo) {
        let view = factory.buildDetailsScreen(imageInfo: details)
        view.showError = { [weak self] error in
            self?.showErrorAlert(error)
        }
        view.close = dismiss
        router.push(view)
    }
    
    func dismiss() {
        router.dismissModule()
    }
}
