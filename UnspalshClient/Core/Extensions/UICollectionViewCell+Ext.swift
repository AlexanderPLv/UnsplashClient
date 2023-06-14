//
//  UICollectionViewCell+Ext.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

protocol ReusableView: NSObjectProtocol {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReusableView {}
