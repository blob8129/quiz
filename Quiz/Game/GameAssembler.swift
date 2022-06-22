//
//  GameAssembler.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import UIKit

final class GameAssembler {
    func assemble() -> UIViewController {
        let url = URL(string: "https://create.kahoot.it/rest/kahoots/fb4054fc-6a71-463e-88cd-243876715bc1")!
        let loader = QuizLoader(source: .network(url))
        return GameViewController(game: Game(loader: loader))
    }
}
