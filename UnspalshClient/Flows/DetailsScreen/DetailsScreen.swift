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
    private let nameLabel: LabelView
    private let locationLabel: LabelView
    private let dateLabel: LabelView
    private let downloadedLabel: LabelView
    
    private var imageInfo: ImageInfo
    
    init(
        imageInfo: ImageInfo
    ) {
        self.imageInfo = imageInfo
        self.nameLabel = LabelView(title: "Name", text: imageInfo.user.name)
        self.locationLabel = LabelView(title: "Location", text: imageInfo.user.location)
        self.dateLabel = LabelView(title: "Date", text: imageInfo.createdAt)
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
    
    @objc func didTapFavoritesButton() {
        favoritesButton.isEnabled = false
        if let image = Image.getImage(by: imageInfo.id) {
            delete(image)
        } else {
            save()
        }
        updateButtonState()
    }
    
    func delete(_ image: Image) {
        do {
            try image.delete()
        } catch let error {
            showError?(error.localizedDescription)
        }
    }
    
    func save() {
        let image = Image(context: Image.viewContext)
        
        image.id = imageInfo.id
        image.userName = imageInfo.user.name
        image.location = imageInfo.user.location
        image.url = imageInfo.urls.small
        image.likes = Int32(imageInfo.likes)
        image.createdAt = imageInfo.createdAt
        
        do {
            try image.save()
        } catch let error {
            showError?(error.localizedDescription)
        }
    }
    
    func updateButtonState() {
        if Image.getImage(by: imageInfo.id) != nil {
            favoritesButton.setImage(UIImage(systemName: "star.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            favoritesButton.setImage(UIImage(systemName: "star.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        }
        favoritesButton.isEnabled = true
    }
    
    func setupViews() {
        view.backgroundColor = .white
        imageView.backgroundColor = .lightGray
        
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
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            favoritesButton.widthAnchor.constraint(equalToConstant: 48.0),
            favoritesButton.heightAnchor.constraint(equalToConstant: 48.0),
            favoritesButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 45.0),
            favoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
        ].forEach { $0.isActive = true }
    }
}
