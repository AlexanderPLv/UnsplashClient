//
//  SearchHeader.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 20.06.2023.
//

import UIKit

final class SearchHeader: UICollectionReusableView, ReusableView {
    
    private let searchBar = UISearchBar()
    weak var delegate: UISearchBarDelegate? {
        didSet {
            searchBar.delegate = delegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchHeader {
    
    func setupView() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.keyboardAppearance = .dark
        searchBar.showsCancelButton = true
        searchBar.tintColor = .black
        
        addSubview(searchBar)
        [
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}
