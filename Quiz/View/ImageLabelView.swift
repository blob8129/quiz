//
//  ImageLabelView.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import UIKit

final class ImageLabelView: UIView {
    
    lazy var imageView = UIImageView()
    
    lazy var textLabel = UILabel()
    
    lazy var stackView: UIStackView = { stv in
        stv.translatesAutoresizingMaskIntoConstraints = false
        return stv
    }(UIStackView(arrangedSubviews: [imageView, textLabel]))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 8),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
