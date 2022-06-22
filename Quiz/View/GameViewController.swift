//
//  GameViewController.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import UIKit
import Combine

final class GameViewController: UIViewController, GameView, AnswersViewDelegate {
   
    private let game: Game
    
    private var allCancellables = Set<AnyCancellable>()
    
    private lazy var questionView: QuestionView = { qtv in
        qtv.translatesAutoresizingMaskIntoConstraints = false
        qtv.quizTitleLabel.imageView.image = UIImage(named: "Quiz")
        qtv.quizTitleLabel.textLabel.text = "Quiz"
        qtv.quizTitleLabel.backgroundColor = .white
        qtv.quizProgressLabel.backgroundColor = .white

        qtv.questionLabel.font = .preferredFont(forTextStyle: .title3)
        
        qtv.resultView.isHidden = true
        qtv.resultLabel.textColor = .white
        qtv.resultLabel.font = .preferredFont(forTextStyle: .largeTitle)
        return qtv
    }(QuestionView())
    
    private lazy var nextQuestionButton: UIButton = { btn in
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(nextQuestionAction(sender:)), for: .touchUpInside)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        btn.setBackgroundImage(UIImage(named: "Button"), for: .normal)
        btn.setContentHuggingPriority(.required, for: .vertical)
        return btn
    }(UIButton(type: .system))
    
    private lazy var answersView: AnswersView = { anv  in
        anv.translatesAutoresizingMaskIntoConstraints = false
        anv.delegate = self
        return anv
    }(AnswersView())
    
    private lazy var backgroundImage: UIImageView = { imv in
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.image = UIImage(named: "Background")
        return imv
    }(UIImageView())
    
    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        addAllSubviews()
        
        game
            .$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &allCancellables)
        
        Task {
            await game.start()
        }
    }
    
    func addAllSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(questionView)
        view.addSubview(answersView)
        view.addSubview(nextQuestionButton)
        
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            view.rightAnchor.constraint(equalTo: backgroundImage.rightAnchor),
            view.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor),
            
            questionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            questionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.rightAnchor.constraint(equalTo: questionView.rightAnchor),
            questionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            answersView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            answersView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 16),
            view.rightAnchor.constraint(equalTo: answersView.rightAnchor, constant: 16),
            
            nextQuestionButton.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
            nextQuestionButton.topAnchor.constraint(equalTo: answersView.bottomAnchor, constant: 16),
            view.rightAnchor.constraint(greaterThanOrEqualTo: nextQuestionButton.rightAnchor),
            nextQuestionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextQuestionButton.bottomAnchor, constant: 16)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        questionView.quizProgressLabel.layer.cornerRadius = questionView.quizProgressLabel.frame.height / 2
        questionView.quizTitleLabel.layer.cornerRadius = questionView.quizTitleLabel.frame.height / 2
    }

    func render(_ state: GameViewState) {
        switch state {
        case .loading:
             // TODO: Show activity indicator
            break
        case .inProgress(let question, let index, let total, let selected):
            questionView.quizProgressLabel.textLabel.text = "\(index)/\(total)"
            questionView.questionLabel.text = question.question
           
            let isAnswerSelected = selected != nil
            if !isAnswerSelected {
                answersView.render(question.choices, at: index)
            }
            nextQuestionButton.isHidden = !isAnswerSelected
            questionView.resultView.isHidden = !isAnswerSelected
            let isAnswerCorrect = selected?.correct == true
            questionView.resultView.backgroundColor = isAnswerCorrect ? .systemGreen : .systemRed
            questionView.resultLabel.text = isAnswerCorrect ? "Correct" : "Wrong"
            guard selected == nil else {
                return
            }
            questionView.imageView.image = nil
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: question.image)
                    questionView.imageView.image = UIImage(data: data)
                } catch {
                    questionView.imageView.image = UIImage(systemName: "text.below.photo")
                }
            }
        case .ended(let score):
            questionView.resultView.isHidden = false
            questionView.resultView.backgroundColor = .systemBlue
            questionView.resultLabel.text = "Done! Score:\(score)"
        case .error:
            // TODO: Show error
           break
        }
    }
    
    // MARK: AnswersViewDelegate
    func didSelectItem(at indexPath: IndexPath) {
        game.send(command: .answer(index: indexPath))
    }
    
    // MARK: Actions
    @objc func nextQuestionAction(sender: UIButton) {
        game.send(command: .nextQuestion)
    }
}
