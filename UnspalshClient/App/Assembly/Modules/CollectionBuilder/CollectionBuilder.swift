//
//  CollectionBuilder.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

protocol CollectionBuilderProtocol {
    func buildCollectionScreen() -> CollectionScreen
    func buildDetailsScreen(imageInfo: ImageInfo) -> DetailsScreen
    func buildErrorAlert(message: String, completionHandler: CompletionBlock?) -> UIAlertController
}

extension ModulesFactory: CollectionBuilderProtocol {
    func buildCollectionScreen() -> CollectionScreen {
        let screen = CollectionScreen(networkService: networkService)
        let config = UIImage.SymbolConfiguration(scale: .large)
        screen.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "photo.on.rectangle", withConfiguration: config)?.withTintColor(.darkGray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "photo.on.rectangle", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        )
        return screen
    }
}
