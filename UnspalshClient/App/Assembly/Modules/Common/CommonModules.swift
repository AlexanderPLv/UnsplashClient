//
//  CommonModules.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

extension ModulesFactory {
    func buildDetailsScreen(imageInfo: ImageInfo) -> DetailsScreen {
        let screen = DetailsScreen(imageInfo: imageInfo)
        return screen
    }
    
    func buildErrorAlert(message: String, completionHandler: CompletionBlock?) -> UIAlertController {
        let controller = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            completionHandler?()
        } )
        return controller
    }
}
