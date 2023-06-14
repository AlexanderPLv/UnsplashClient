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
    
    private var items = [ImageInfo]()
    private let collectionView: UICollectionView
    
    var fetchedResultsController: NSFetchedResultsController<Image>!
    
    init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       // fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
}

private extension FavoritesScreen {
    
    func fetchData() {
        if fetchedResultsController == nil {
            let request: NSFetchRequest<Image> = Image.fetchRequest()
            let sort = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [sort]

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Image.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }

        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 30.0, left: 0.0, bottom: 10.0, right: 0.0)
        collectionView.register(
            FavoritesScreenCell.self,
            forCellWithReuseIdentifier: FavoritesScreenCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
