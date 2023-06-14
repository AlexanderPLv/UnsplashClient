//
//  FavoritesScreenCell.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit
import SDWebImage

final class FavoritesScreenCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16.0)
        view.textColor = .black
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()
    
    var item: ImageInfo? {
        didSet {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            guard let item, let url = URL(string: item.urls.small) else { return }
            imageView.sd_setImage(with: url)
            nameLabel.text = item.user.name
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FavoritesScreenCell {
    func setupViews() {
        
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel])
        stack.axis = .horizontal
        stack.spacing = 20.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        addSubview(stack)
        addSubview(separatorView)
        [
            imageView.widthAnchor.constraint(equalToConstant: 50.0),
            imageView.heightAnchor.constraint(equalToConstant: 50.0),
            
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.0),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.0),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.widthAnchor.constraint(equalTo: stack.widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ].forEach { $0.isActive = true }
    }
}
