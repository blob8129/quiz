//
//  Game.swift
//  Quiz
//
//  Created by Andrey Volobuev on 19/06/2022.
//

import Foundation

enum GameViewState: Equatable {
    case loading
    case inProgress(Question, index: Int, total: Int, selected: Question.Choice?)
    case ended(score: Int)
    case error
}

extension Game.State {
    func conver() -> GameViewState {
        switch self {
        case .loading:
            return .loading
        case .inProgress(let quiz, let index, let progress, _):
            let question = quiz.questions[index]
            var selected: Question.Choice?
            if case .answer(let answerIndex) = progress {
                selected = question.choices[answerIndex]
            }
            return .inProgress(quiz.questions[index],
                               index: index,
                               total: quiz.questions.count,
                               selected: selected)
        case .ended(let quiz, let answers):
            return .ended(score: 0)
        case .error(_):
            return .error
        }
    }
    
    func handle(_ command: GameCommand) -> Self {
        switch command {
        case .answer(let indexPath):
            switch self {
            case .inProgress(let quiz, let index, _, var answers):
                let question = quiz.questions[indexPath.section]
                let answer = Answer(question: question,
                                    selected: question.choices[indexPath.row])
                answers.append(answer)
                return .inProgress(quiz,
                                   index: index,
                                   .answer(indexPath.row),
                                   answers)
            default:
                return self
            }
        case .nextQuestion:
            switch self {
            case .inProgress(let quiz, let index, _, let answers):
                let nextIndex = index + 1
                if nextIndex > quiz.questions.count - 1 {
                    return .ended(quiz, answers)
                }
                return .inProgress(quiz, index: nextIndex, .question, answers)
            case .ended(let quiz, _):
                return .inProgress(quiz, index: 0, .question, [])
            default:
                return self
            }
        }
    }
}

final class Game {
    
    enum State {
        enum Progress {
            case question
            case answer(Int)
        }
        case loading
        case inProgress(Quiz, index: Int, Progress, [Answer])
        case ended(Quiz, [Answer])
        case error(String)
    }
    
    private let loader: QuizLoader
    private var state = State.loading {
        didSet {
            viewState = state.conver()
        }
    }
    @Published var viewState: GameViewState = .loading
    
    func start() async {
        do {
            guard let quiz = try await loader.loadNext() else {
                state = .error("Game not found")
                return
            }
            guard !quiz.questions.isEmpty else {
                state = .ended(quiz, [])
                return
            }
            state = .inProgress(quiz, index: 0, .question, [])
        } catch {
            // TODO: Handle error
            print(error.localizedDescription)
        }
    }
    
    func send(command: GameCommand) {
        state = state.handle(command)
    }
    
    init(loader: QuizLoader) {
        self.loader = loader
    }
}
