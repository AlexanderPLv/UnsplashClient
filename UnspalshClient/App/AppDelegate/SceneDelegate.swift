//
//  SceneDelegate.swift
//  UnspalshClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    var rootController: UINavigationController {
        window?.rootViewController = UINavigationController()
        window?.rootViewController?.view.backgroundColor = .white
        guard let controller = window?.rootViewController as? UINavigationController
        else { return UINavigationController() }
        return controller
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = self.window ?? UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator.build(
            router: Router(rootController: rootController),
            window: window
        )
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
