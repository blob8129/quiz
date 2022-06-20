//
//  QuestionView.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import UIKit

final class QuestionView: UIView {
    
    lazy var quizProgressLabel: ImageLabelView = { ilv in
        ilv.translatesAutoresizingMaskIntoConstraints = false
        return ilv
    }(ImageLabelView())
    
    lazy var quizTitleLabel: ImageLabelView = { ilv in
        ilv.translatesAutoresizingMaskIntoConstraints = false
        return ilv
    }(ImageLabelView())
    
    lazy var resultView: UIView = { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }(UIView())
    
    lazy var resultLabel: UILabel = { lbl in
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }(UILabel())
    
    private lazy var imageView: UIImageView = { imv in
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.image = UIImage(named: "Sample")
        imv.contentMode = .scaleAspectFit
        imv.layer.cornerRadius = 4
        return imv
    }(UIImageView())
    
    lazy var questionLabel: UILabel = { lbl in
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 4
        lbl.backgroundColor = .white
        lbl.textColor = .black
        lbl.text = "What is the capital of France?"
        return lbl
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(quizProgressLabel)
        addSubview(quizTitleLabel)
        addSubview(resultView)
        addSubview(imageView)
        addSubview(questionLabel)
        
        resultView.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultView.leftAnchor.constraint(equalTo: leftAnchor),
            resultView.topAnchor.constraint(equalTo: topAnchor),
            rightAnchor.constraint(equalTo: resultView.rightAnchor),
            
            resultLabel.leftAnchor.constraint(equalTo: resultView.leftAnchor),
            resultLabel.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 0),
            resultView.rightAnchor.constraint(equalTo: resultLabel.rightAnchor),
            resultView.bottomAnchor.constraint(equalTo: resultLabel.bottomAnchor),
            resultView.bottomAnchor.constraint(equalTo: quizTitleLabel.bottomAnchor, constant: 16),
            
            quizProgressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            quizProgressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
          
            quizTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            quizTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 16),
            rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: 16),
            
            questionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            rightAnchor.constraint(equalTo: questionLabel.rightAnchor, constant: 16),
            bottomAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 16)
        ])
    }
}

