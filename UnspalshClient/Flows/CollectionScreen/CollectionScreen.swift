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
            UIView.performWithoutAnimation {
                collectionView.reloadSections([1])
                collectionView.layoutIfNeeded()
            }
        }
    }
    private let collectionView: UICollectionView
    private let networkService: NetworkService
    private var currentPage = 0
    private var loadInProgress = false
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
        setupCollectionView()
        load(page: 1)
    }
}

extension CollectionScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

private extension CollectionScreen {
    
    func search(_ text: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            guard !text.isEmpty else {
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
    
    func load(page: Int) {
        guard !loadInProgress else { return }
        loadInProgress = true
        networkService.getImageList(page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.currentPage = page
                    self?.items.append(contentsOf: items)
                case .failure(let error):
                    self?.showError?(error.localizedDescription)
                }
                self?.loadInProgress = false
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        collectionView.register(
            CollectionScreenCell.self,
            forCellWithReuseIdentifier: CollectionScreenCell.reuseIdentifier
        )
        collectionView.register(
            SearchHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchHeader.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        [
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}

extension CollectionScreen: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return items.count
        default:
            return 0
        }
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
        var descriptionHeight: CGFloat = 0
        if let description = items[indexPath.item].description {
            descriptionHeight = description.height(
                withConstrainedWidth: collectionView.bounds.size.width - 40.0,
                font: .systemFont(ofSize: 14.0),
                maxHeight: 40.0
            )
        }
        return CGSize(
            width: collectionView.bounds.size.width,
            height: collectionView.bounds.size.width + descriptionHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onDetailScreen?(items[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item > items.count - 4 else { return }
        let nextPage = currentPage + 1
        load(page: nextPage)
    }
    
    //MARK: - Header
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchHeader.reuseIdentifier,
                for: indexPath
            ) as? SearchHeader else { fatalError("dequeueReusableSupplementaryHeaderError.") }
            header.delegate = self
            return header
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 50.0)
        default:
            return .zero
        }
    }
}
