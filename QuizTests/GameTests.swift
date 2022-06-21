//
//  GameTests.swift
//  QuizTests
//
//  Created by Andrey Volobuev on 19/06/2022.
//

import XCTest
import Combine
@testable import Quiz

class GameTests: XCTestCase {
    
    private var allCancellables = Set<AnyCancellable>()
    
    func testGameLoading() async throws {
        let game = Game(loader: QuizLoader(source: .local(quizJsonData)))
        
        game.$viewState.first().sink { state in
            XCTAssertEqual(state, .loading)
        }.store(in: &allCancellables)
        
        await game.start()
    }
    
    func testGameEndedIfQuestionEmpty() async throws {
        let game = Game(loader: QuizLoader(source: .local(quizJsonData)))
        
        game.$viewState.dropFirst().sink { state in
            XCTAssertEqual(state, .ended(score: 0))
        }.store(in: &allCancellables)
        
        await game.start()
    }
    
    func testGameFirstQuestion() async throws {
        let game = Game(loader: QuizLoader(source: .local(localGameDate)))
        
        game.$viewState.dropFirst().sink { state in
            if case .inProgress(let question,
                                let index,
                                let total,
                                let selected) = state {
                XCTAssertEqual(question.question, "<b>True or false: </b>The list of seven wonders is based on ancient Greek guidebooks for tourists.")
                XCTAssertEqual(index, 0)
                XCTAssertEqual(total, 12)
                XCTAssertNil(selected)
            } else {
                XCTFail()
            }
        }.store(in: &allCancellables)
        
        await game.start()
    }
    
    func testGameFirstQuestionAnswer0() async throws {
        let game = Game(loader: QuizLoader(source: .local(localGameDate)))
        
        game.$viewState.dropFirst(2).sink { state in
            if case .inProgress(let question,
                                let index,
                                let total,
                                let selected) = state {
                XCTAssertEqual(question.question, "<b>True or false: </b>The list of seven wonders is based on ancient Greek guidebooks for tourists.")
                XCTAssertEqual(index, 0)
                XCTAssertEqual(total, 12)
                XCTAssertEqual(selected, Question.Choice(answer: "True",
                                                         correct: true))
            } else {
                XCTFail()
            }
        }.store(in: &allCancellables)
        
        await game.start()
        game.send(command: .answer(index: IndexPath(item: 0, section: 0)))
    }
    
    func testGameFirstQuestionAnswer1() async throws {
        let game = Game(loader: QuizLoader(source: .local(localGameDate)))
        
        game.$viewState.dropFirst(2).sink { state in
            if case .inProgress(let question,
                                let index,
                                let total,
                                let selected) = state {
                XCTAssertEqual(question.question, "<b>True or false: </b>The list of seven wonders is based on ancient Greek guidebooks for tourists.")
                XCTAssertEqual(index, 0)
                XCTAssertEqual(total, 12)
                XCTAssertEqual(selected, Question.Choice(answer: "False",
                                                         correct: false))
            } else {
                XCTFail()
            }
        }.store(in: &allCancellables)
        
        await game.start()
        game.send(command: .answer(index: IndexPath(item: 1, section: 0)))
    }
    
    func testGameFirstQuestionNextQuestion() async throws {
        let game = Game(loader: QuizLoader(source: .local(localGameDate)))
        
        game.$viewState.dropFirst(3).sink { state in
            if case .inProgress(let question,
                                let index,
                                let total,
                                let selected) = state {
                XCTAssertEqual(question.question, "The Great Pyramid of Giza is the oldest of the wonders. What was its purpose?")
                XCTAssertEqual(index, 1)
                XCTAssertEqual(total, 12)
                XCTAssertNil(selected)
            } else {
                XCTFail()
            }
        }.store(in: &allCancellables)
        
        await game.start()
        game.send(command: .answer(index: IndexPath(item: 1, section: 0)))
        game.send(command: .nextQuestion)
    }
    
    func testAllQuestionsGameEnded() async throws {
        let game = Game(loader: QuizLoader(source: .local(localGameDate)))
        
        await game.start()
        (0..<11).forEach {
            game.send(command: .answer(index: IndexPath(item: 0, section: $0)))
            game.send(command: .nextQuestion)
        }
        
        game.$viewState.dropFirst(2).sink { state in
            if case .ended(let score) = state {
                XCTAssertEqual(score, 3)
            } else {
                XCTFail()
            }
        }.store(in: &allCancellables)
        
        game.send(command: .answer(index: IndexPath(item: 0, section: 11)))
        game.send(command: .nextQuestion)
    }
}
