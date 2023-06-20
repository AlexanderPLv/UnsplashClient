//
//  FavoritesBuilder.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

protocol FavoritesBuilderProtocol {
    func buildFavoritesScreen() -> FavoritesScreen
    func buildDetailsScreen(imageInfo: ImageInfo) -> DetailsScreen
    func buildErrorAlert(message: String, completionHandler: CompletionBlock?) -> UIAlertController
}

extension ModulesFactory: FavoritesBuilderProtocol {
    func buildFavoritesScreen() -> FavoritesScreen {
        let screen = FavoritesScreen(fetchedResultsController: dataManager.createImageFetchedResultController())
        let config = UIImage.SymbolConfiguration(scale: .large)
        screen.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.darkGray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        )
        return screen
    }
}
