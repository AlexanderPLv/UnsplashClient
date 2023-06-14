//
//  LabelView.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

final class LabelView: UIView {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16.0)
        view.textColor = .black
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16.0)
        view.textColor = .black
        view.numberOfLines = 1
        view.textAlignment = .right
        return view
    }()
    
    init(
        title: String,
        text: String?
    ) {
        self.titleLabel.text = title
        self.textLabel.text = text
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LabelView {
    
    func setupView() {
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let stack = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        stack.axis = .horizontal
        stack.spacing = 20.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        [
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.0),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.0),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}
