//
//  CollectionScreen.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import UIKit

final class CollectionScreen: UIViewController {
    
    var close: CompletionBlock?
    var onDetailScreen: ((ImageInfo) -> ())?
    var showError: ((String) -> ())?
    
    private var items = [ImageInfo]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let collectionView: UICollectionView
    private let networkService: NetworkService
    private let searchBar = SearchView()
    private var currentPage = 0
    var timer: Timer?
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        load(page: 1)
    }
    
    func search(_ text: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            guard !text.isEmpty else {
                self.load(page: 1)
                return
            }
            self.networkService.search(query: text) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let items):
                        self?.items = items
                    case .failure(let error):
                        self?.showError?(error.localizedDescription)
                    }
                }
            }
        })
    }
    
}

private extension CollectionScreen {
    
    func load(page: Int) {
        networkService.getImageList(page: page) { [weak self] result in
            DispatchQueue.main.async {
            switch result {
            case .success(let items):
                self?.currentPage = page
                self?.items.append(contentsOf: items)
            case .failure(let error):
                    self?.showError?(error.localizedDescription)
                }
            }
        }
    }
    
    func setupSearchBar() {
        
        searchBar.onTextChange = { [weak self] text in
            self?.search(text)
        }
        searchBar.onReturn = { [weak self] in
            self?.searchBar.textField.resignFirstResponder()
        }
        searchBar.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.addSubview(searchBar)
        [
            searchBar.heightAnchor.constraint(equalToConstant: 40.0),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30.0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.0),
        ].forEach{ $0.isActive = true }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        collectionView.register(
            CollectionScreenCell.self,
            forCellWithReuseIdentifier: CollectionScreenCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        [
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}

extension CollectionScreen: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionScreenCell.reuseIdentifier,
            for: indexPath
        ) as? CollectionScreenCell else {
            fatalError("Dequeue CollectionScreenCell error.")
        }
        cell.item = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.bounds.size.width,
            height: collectionView.bounds.size.width
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onDetailScreen?(items[indexPath.item])
    }
}
