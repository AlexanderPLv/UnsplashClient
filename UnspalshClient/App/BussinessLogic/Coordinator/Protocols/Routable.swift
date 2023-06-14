//
//  Routable.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

typealias CompletionBlock = (() -> Void)

protocol Routable: Presentable {

    func present(_ module: Presentable?)
    func presentFullScreen(_ module: Presentable?, animated: Bool)
    func presentOverFullScreen(_ module: Presentable?, animated: Bool)
    func presentFullScreenFromModalController(_ module: Presentable?, animated: Bool)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?)
    func push(_ module: Presentable?, customTransition: Bool)

    func popModule()
    func popModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: CompletionBlock?)
    func dismissModuleOneStepBack(animated: Bool, completion: CompletionBlock?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)

    func popToRootModule(animated: Bool)
}
