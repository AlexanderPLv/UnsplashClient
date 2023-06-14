//
//  SearchView.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import UIKit

class SearchView: UIView {
    
    var onTextChange: ((String) -> Void)?
    var onReturn: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20.0
        clipsToBounds = true
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(textField)
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = UIColor.black
        textField.delegate = self
        
        textField.returnKeyType = .search
        textField.leftView = textFieldLeftView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    lazy var textFieldLeftView: UIView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        let view = UIView()
        let frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        view.frame = frame
        view.addSubview(imageView)
        
        imageView.contentMode = .center
        imageView.frame = frame
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let textFieldSize = CGSize(width: bounds.width - insets.left - insets.right, height: 40)
        textField.frame = CGRect(origin: .zero, size: textFieldSize).centrize(in: bounds)
    }
    
    static var height: CGFloat {
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return 40 + insets.top + insets.bottom
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var placeholder: String?
}

extension SearchView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            onTextChange?(newText)
            textField.text = newText
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        return true
    }
}

extension CGRect {
    init(size: CGSize) {
        self.init(origin: CGPoint.zero, size: size)
    }
    
    func centrize(in parentRect: CGRect) -> CGRect {
        var rect = self
        rect = rect.centrizeVertically(in: parentRect).centrizeHorizontally(in: parentRect)
        return rect
    }
    
    func centrizeVertically(in parentRect: CGRect) -> CGRect {
        var rect = self
        rect.origin.y = (parentRect.height - rect.height) / 2
        return rect
    }
    
    func centrizeHorizontally(in parentRect: CGRect) -> CGRect {
        var rect = self
        rect.origin.x = (parentRect.width - rect.width) / 2
        return rect
    }
}
