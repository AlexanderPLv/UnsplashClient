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
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 14.0)
        view.textColor = .lightGray
        view.numberOfLines = 2
        view.textAlignment = .left
        return view
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 3.0
        view.layer.masksToBounds = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16.0)
        view.textColor = .darkText
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()
    
    var item: ImageInfo? {
        didSet {
            guard let item else {
                return
            }
            nameLabel.text = item.user.name
            descriptionLabel.text = item.description
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            guard let url = URL(string: item.urls.small) else {
                return
            }
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
        
        
        addSubview(background)
        background.addSubview(descriptionLabel)
        background.addSubview(nameLabel)
        background.addSubview(imageView)
        [
            background.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -5.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20.0),
            
            nameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -5.0),
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20.0),
            nameLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20.0),
            
            imageView.topAnchor.constraint(equalTo: background.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10.0),
        ].forEach { $0.isActive = true }
    }
}
