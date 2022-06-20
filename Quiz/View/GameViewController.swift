//
//  GameViewController.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import UIKit

final class GameViewController: UIViewController, GameView {
    
    private lazy var questionView: QuestionView = { qtv in
        qtv.translatesAutoresizingMaskIntoConstraints = false
        qtv.backgroundColor = .red
        qtv.quizTitleLabel.imageView.image = UIImage(named: "Quiz")
        qtv.quizTitleLabel.textLabel.text = "Quiz"
        qtv.quizTitleLabel.backgroundColor = .white
        qtv.quizProgressLabel.textLabel.text = "0/12"
        qtv.quizProgressLabel.backgroundColor = .white
        qtv.resultView.backgroundColor = .yellow
        qtv.resultLabel.text = "Correct"
        return qtv
    }(QuestionView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        addAllSubviews()
    }

    func addAllSubviews() {
        view.addSubview(questionView)
        NSLayoutConstraint.activate([
            questionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            questionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.rightAnchor.constraint(equalTo: questionView.rightAnchor),
            questionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        questionView.quizProgressLabel.layer.cornerRadius = questionView.quizProgressLabel.frame.height / 2
        questionView.quizTitleLabel.layer.cornerRadius = questionView.quizTitleLabel.frame.height / 2
    }

    func render(_ state: GameViewState) {
        
    }
}
