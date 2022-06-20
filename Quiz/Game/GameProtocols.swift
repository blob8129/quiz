//
//  GameProtocols.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import Foundation

protocol GameView: AnyObject {
    func render(_ state: GameViewState)
}

enum GameCommand {
    case answer(index: IndexPath)
    case nextQuestion
}
