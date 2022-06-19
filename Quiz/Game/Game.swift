//
//  Game.swift
//  Quiz
//
//  Created by Andrey Volobuev on 19/06/2022.
//

import Foundation

struct Answer {
    let question: Question
    let selected: Question.Choice
}

enum GameViewState: Equatable {
    case loading
    case inProgress(Question, index: Int, total: Int, selected: Question.Choice?)
    case ended(score: Int)
    case error
}

protocol GameView: AnyObject {
    func render(_ state: GameViewState)
}

extension Game.State {
    func conver() -> GameViewState {
        switch self {
        case .loading:
            return .loading
        case .inProgress(let quiz, let answers):
            let (question, index, total) = convert(quiz, answers)
            return .inProgress(question, index: index, total: total, selected: nil)
        case .ended(let quiz, let answers):
            return .ended(score: 0)
        case .error(_):
            return .error
        }
    }
    
    func convert(_ quiz: Quiz,
                 _ answers: [Answer]) -> (Question, index: Int, total: Int) {
        (quiz.questions[answers.count],
         index: answers.count + 1,
         total: quiz.questions.count)
    }
}

final class Game {
    
    enum State {
        case loading
        case inProgress(Quiz, [Answer])
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
            state = .inProgress(quiz, [])
        } catch {
            // TODO: Handle error
            print(error.localizedDescription)
        }
    }
    
    init(loader: QuizLoader) {
        self.loader = loader
    }
}

final class QuizLoader {
    
    enum Source {
        case network(URL)
        case local(Data)
    }
    
    private var sources: [Source]
    private let decoder: JSONDecoder
    
    func loadNext() async throws -> Quiz? {
        guard let firstSource = sources.first else {
            return nil
        }
        switch firstSource {
        case .network(let url):
            print(url)
            return nil
        case .local(let data):
            return try decoder.decode(Quiz.self, from: data)
        }
    }
    
    init(source: Source, decoder: JSONDecoder = JSONDecoder()) {
        self.sources = [source]
        self.decoder = decoder
    }
}
