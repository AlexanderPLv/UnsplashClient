//
//  Presentable.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

protocol Presentable {
    var toPresent: UIViewController? { get }
}
 
extension UIViewController: Presentable {
    var toPresent: UIViewController? {
        return self
    }
}
