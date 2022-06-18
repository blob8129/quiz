//
//  Question.swift
//  Quiz
//
//  Created by Andrey Volobuev on 18/06/2022.
//

import Foundation

struct Question: Codable {
    struct Choice: Codable, Equatable {
        let answer: String
        let correct: Bool
    }
    let question: String
    let time: Int
    let points: Bool
    let pointsMultiplier: Int
    let image: URL
    let choices: [Choice]
}
