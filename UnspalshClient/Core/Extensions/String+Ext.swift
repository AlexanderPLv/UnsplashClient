//
//  String+Ext.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 18.06.2023.
//

import UIKit

extension String {
    public func height(withConstrainedWidth width: CGFloat, font: UIFont, maxHeight: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
