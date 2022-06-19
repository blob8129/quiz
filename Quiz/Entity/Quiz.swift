//
//  Quiz.swift
//  Quiz
//
//  Created by Andrey Volobuev on 19/06/2022.
//

import Foundation

struct Quiz: Codable, Equatable {
    let uuid: UUID
    let title: String
    let description: String
    let cover: URL
    let questions: [Question]
}
