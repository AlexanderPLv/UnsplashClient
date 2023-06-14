//
//  Router.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

typealias RouterCompletions = [UIViewController: CompletionBlock]

final class Router: NSObject {
    fileprivate var rootController: UINavigationController?
    fileprivate var completions: RouterCompletions

    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    class func build(with rootController: UINavigationController) -> Router {
        return Router(rootController: rootController)
    }

    var toPresent: UIViewController? {
     //   guard let rootController = rootController else { fatalError("Root Controller were nil.") }
        return rootController
     }
}

private extension Router {
    func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension Router: Routable {

    func present(_ module: Presentable?) {
        presentFullScreen(module, animated: true)
    }

    func presentFullScreen(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        controller.modalPresentationStyle = .fullScreen
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func presentFullScreenFromModalController(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        controller.modalPresentationStyle = .fullScreen
        if let presentedViewController = rootController?.presentedViewController {
            presentedViewController.present(controller, animated: animated, completion: nil)
        }
    }
    func presentOverFullScreen(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        controller.modalPresentationStyle = .overFullScreen
        if let presentedViewController = rootController?.presentedViewController {
            presentedViewController.present(controller, animated: animated, completion: nil)
        }
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
        else { assertionFailure("⚠️Deprecated push UINavigationController."); return }

        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }

    func push(_ module: Presentable?, customTransition: Bool) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
        else { assertionFailure("⚠️Deprecated push UINavigationController."); return }
        if customTransition {
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(
                name: CAMediaTimingFunctionName.easeInEaseOut
            )
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            rootController?.view.layer.add(transition, forKey: nil)
        }
        rootController?.pushViewController(controller, animated: false)
    }

    func popModule() {
        popModule(animated: true)
    }

    func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: CompletionBlock?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func dismissModuleOneStepBack(animated: Bool, completion: CompletionBlock?) {
        if let presentedViewController = rootController?.presentedViewController {
            presentedViewController.dismiss(animated: animated, completion: completion)
        }
    }

    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
        rootController?.modalPresentationStyle = .fullScreen
    }

    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
}
