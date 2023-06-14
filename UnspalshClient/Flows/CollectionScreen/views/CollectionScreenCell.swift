//
//  CollectionScreenCell.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit
import SDWebImage

final class CollectionScreenCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    var item: ImageInfo? {
        didSet {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            guard let item, let url = URL(string: item.urls.small) else { return }
            imageView.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CollectionScreenCell {
    func setupViews() {
        imageView.backgroundColor = .lightGray
        addSubview(imageView)
        [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}
