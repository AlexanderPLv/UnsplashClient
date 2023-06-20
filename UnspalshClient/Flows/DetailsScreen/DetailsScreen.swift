//
//  DetailsScreen.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit
import SDWebImage

final class DetailsScreen: UIViewController {
    
    var close: CompletionBlock?
    var showError: ((String) -> ())?
    
    private lazy var favoritesButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(
            UIImage(systemName: "star.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        view.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(
            UIImage(systemName: "arrow.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        view.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return view
    }()
    
    private let nameLabel: LabelView
    private let locationLabel: LabelView
    private let dateLabel: LabelView
    private let downloadedLabel: LabelView
    
    private var imageInfo: ImageInfo
    private let dataManager: ImageDataManager
    
    init(
        imageInfo: ImageInfo,
        dataManager: ImageDataManager
    ) {
        self.imageInfo = imageInfo
        self.dataManager = dataManager
        self.nameLabel = LabelView(title: "Name", text: imageInfo.user.name)
        self.locationLabel = LabelView(title: "Location", text: imageInfo.user.location)
        self.dateLabel = LabelView(title: "Date", text: imageInfo.shortDate)
        self.downloadedLabel = LabelView(title: "Downloaded", text: String(imageInfo.likes))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateButtonState()
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let url = URL(string: imageInfo.urls.small) else { return }
        imageView.sd_setImage(with: url)
    }
}

private extension DetailsScreen {
    
    @objc func didTapBackButton() {
        close?()
    }
    
    @objc func didTapFavoritesButton() {
        do {
            if let image = dataManager.getImage(by: imageInfo.id) {
                try dataManager.delete(image)
            } else {
                try dataManager.save(imageInfo)
            }
        } catch let error {
            showError?(error.localizedDescription)
        }
        updateButtonState()
    }
    
    func updateButtonState() {
        let color: UIColor = dataManager.isImageExist(with: imageInfo.id) ? .yellow : .black
        favoritesButton.setImage(
            UIImage(systemName: "star.fill")?.withTintColor(color, renderingMode: .alwaysOriginal),
            for: .normal
        )
    }
    
    func setupViews() {
        view.backgroundColor = .white
        imageView.backgroundColor = .lightGray
        
        locationLabel.isHidden = imageInfo.user.location == nil
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .init(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let stack = UIStackView(arrangedSubviews: [
            imageView, nameLabel, locationLabel, dateLabel, downloadedLabel
        ])
        stack.axis = .vertical
        stack.spacing = 12.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stack)
        view.addSubview(scrollView)
        view.addSubview(favoritesButton)
        view.addSubview(backButton)
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 48.0),
            backButton.heightAnchor.constraint(equalToConstant: 48.0),
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20.0),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            
            favoritesButton.widthAnchor.constraint(equalToConstant: 48.0),
            favoritesButton.heightAnchor.constraint(equalToConstant: 48.0),
            favoritesButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20.0),
            favoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
            
            stack.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}
