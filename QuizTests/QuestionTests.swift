//
//  QuestionTests.swift
//  QuizTests
//
//  Created by Andrey Volobuev on 18/06/2022.
//

import XCTest
@testable import Quiz

let questionJsonData =
"""
{
    "type": "quiz",
    "question": "Test question",
    "time": 20000,
    "points": true,
    "pointsMultiplier": 1,
    "choices": [{
            "answer": "True",
            "correct": true,
            "languageInfo": {
                "language": "en-US",
                "lastUpdatedOn": 1655027478017,
                "readAloudSupported": true
            }
        },
        {
            "answer": "False",
            "correct": false,
            "languageInfo": {
                "language": "en-US",
                "lastUpdatedOn": 1655027478017,
                "readAloudSupported": true
            }
        }
    ],
    "image": "https://media.kahoot.it/8d195530-548a-423e-8604-47f0cabd96e6_opt",
    "imageMetadata": {
        "id": "8d195530-548a-423e-8604-47f0cabd96e6",
        "contentType": "image/*",
        "effects": [],
        "resources": "Photo by Dariusz Sankowski on Unsplash /CCO"
    },
    "resources": "Photo by Dariusz Sankowski on Unsplash /CCO",
    "video": {
        "id": "",
        "startTime": 0,
        "endTime": 0,
        "service": "youtube",
        "fullUrl": ""
    },
    "questionFormat": 0,
    "languageInfo": {
        "language": "en-US",
        "lastUpdatedOn": 1655027478017,
        "readAloudSupported": true
    },
    "media": []
}
""".data(using: .utf8) ?? Data()

class QuestionTests: XCTestCase {

    let testDecoder = JSONDecoder()
    
    func testQuestionDecoding() throws {
        let entity = try testDecoder.decode(Question.self, from: questionJsonData)
       
        XCTAssertEqual(entity.question, "Test question")
        XCTAssertEqual(entity.time, 20000)
        XCTAssertEqual(entity.points, true)
        XCTAssertEqual(entity.pointsMultiplier, 1)
        XCTAssertEqual(entity.image, URL(string: "https://media.kahoot.it/8d195530-548a-423e-8604-47f0cabd96e6_opt")!)
        XCTAssertEqual(entity.choices.count, 2)
        XCTAssertEqual(entity.choices.first, Question.Choice(answer: "True", correct: true))
        XCTAssertEqual(entity.choices.dropFirst().first, Question.Choice(answer: "False", correct: false))
    }
}
