//
//  AnswersView.swift
//  Quiz
//
//  Created by Andrey Volobuev on 21/06/2022.
//

import UIKit

protocol AnswersViewDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
}

final class AnswersView: UIView {
    
    weak var delegate: AnswersViewDelegate?
    
    private var questionIndex = -1
    lazy var button1 = UIButton(type: .system)
    lazy var button2 = UIButton(type: .system)
    lazy var button3 = UIButton(type: .system)
    lazy var button4 = UIButton(type: .system)
    
    private lazy var allButtons = [button1, button2, button3, button4]
    
    private lazy var lhsSackView: UIStackView = { stv in
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 8
        return stv
    }(UIStackView(arrangedSubviews: [
        button1,
        button4
    ]))
    
    private lazy var rhsSackView: UIStackView = { stv in
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 8
        return stv
    }(UIStackView(arrangedSubviews: [
        button2,
        button3
    ]))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        button1.setBackgroundImage(UIImage(named: "Red"), for: .normal)
        button2.setBackgroundImage(UIImage(named: "Blue"), for: .normal)
        button3.setBackgroundImage(UIImage(named: "Green"), for: .normal)
        button4.setBackgroundImage(UIImage(named: "Brown"), for: .normal)
        [button1, button2, button3, button4].enumerated().forEach { offset, button in
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.numberOfLines = 0
            button.tag = offset
            button.addTarget(self,
                             action: #selector(touchUpInsideAction(sender:)),
                             for: .touchUpInside)
        }

        addSubview(lhsSackView)
        addSubview(rhsSackView)
        NSLayoutConstraint.activate([
            lhsSackView.leftAnchor.constraint(equalTo: leftAnchor),
            lhsSackView.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: lhsSackView.bottomAnchor),
            
            rhsSackView.leftAnchor.constraint(equalTo: lhsSackView.rightAnchor, constant: 8),
            rhsSackView.topAnchor.constraint(equalTo: topAnchor),
            rightAnchor.constraint(equalTo: rhsSackView.rightAnchor),
            bottomAnchor.constraint(equalTo: rhsSackView.bottomAnchor),
            rhsSackView.widthAnchor.constraint(equalTo: lhsSackView.widthAnchor)
        ])
    }
    
    func render(_ choices: [Question.Choice], at index: Int) {
        allButtons.forEach { $0.isHidden = true }
        questionIndex = index
        zip(allButtons, choices).forEach {
            let (btn, choice) = $0
            btn.setTitle(choice.answer, for: .normal)
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            btn.titleLabel?.font = .preferredFont(forTextStyle: .headline)
            btn.tintColor = .clear
            btn.isSelected = false
            btn.isHidden = false
            btn.isUserInteractionEnabled = true
            btn.setBackgroundImage(choice.correct ? UIImage(named: "Correct") : UIImage(named: "Incorrect"),
                                   for: .selected)
        }
    }
    
    @objc func touchUpInsideAction(sender: UIButton) {
        allButtons.forEach { btn in
            btn.isSelected = true
            btn.isUserInteractionEnabled = false
        }
        delegate?.didSelectItem(at: IndexPath(item: sender.tag, section: questionIndex))
    }
}
