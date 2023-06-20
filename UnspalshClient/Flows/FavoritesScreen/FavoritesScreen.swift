//
//  FavoritesScreen.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit
import CoreData

final class FavoritesScreen: UIViewController {
    
    var close: CompletionBlock?
    var onDetailScreen: ((ImageInfo) -> ())?
    var showError: ((String) -> ())?
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 32.0)
        view.textColor = .black
        view.numberOfLines = 1
        view.text = "Favorites"
        view.textAlignment = .left
        return view
    }()
    
    private var items = [ImageInfo]()
    private let collectionView: UICollectionView
    
    private let fetchedResultsController: NSFetchedResultsController<Image>
    
    init(
        fetchedResultsController: NSFetchedResultsController<Image>
    ) {
        self.fetchedResultsController = fetchedResultsController
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
}

private extension FavoritesScreen {
    
    func fetchData() {
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {
            showError?(error.localizedDescription)
        }
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        [
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20.0),
        ].forEach { $0.isActive = true }
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 15.0, left: 0.0, bottom: 10.0, right: 0.0)
        collectionView.register(
            FavoritesScreenCell.self,
            forCellWithReuseIdentifier: FavoritesScreenCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}

extension FavoritesScreen: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesScreenCell.reuseIdentifier,
            for: indexPath
        ) as? FavoritesScreenCell else {
            fatalError("Dequeue CollectionScreenCell error.")
        }
        let image = fetchedResultsController.object(at: indexPath)
        cell.item = ImageInfo(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.bounds.size.width,
            height: 70.0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = fetchedResultsController.object(at: indexPath)
        guard let item = ImageInfo(image: image) else { return }
        onDetailScreen?(item)
    }
}
