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
                XCTAssertEqual(index, 1)
                XCTAssertEqual(total, 12)
                XCTAssertNil(selected)
            } else {
                XCTFail()
            }
        }.store(in: &allCancellables)
        
        await game.start()
    }
}
