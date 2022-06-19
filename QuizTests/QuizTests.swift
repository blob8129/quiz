//
//  QuizTests.swift
//  QuizTests
//
//  Created by Andrey Volobuev on 16/06/2022.
//

import XCTest
@testable import Quiz

let quizJsonData =
#"""
{
    "uuid": "fb4054fc-6a71-463e-88cd-243876715bc1",
    "language": "English",
    "creator": "4c1574ee-de54-40a2-be15-8d72b333afad",
    "creator_username": "KahootStudio",
    "compatibilityLevel": 6,
    "creator_primary_usage": "teacher",
    "folderId": "4c1574ee-de54-40a2-be15-8d72b333afad",
    "themeId": "kahoot_e2846802-42bc-4e13-ac37-9dcdcc48fb22",
    "visibility": 1,
    "audience": "Social",
    "title": "Seven Wonders of the Ancient World",
    "description": "A #geography #quiz about the #Seven #Wonders of the #Ancient #World. See how much you know about these ancient buildings and monuments!\n#trivia #history #studio",
    "quizType": "quiz",
    "cover": "https://media.kahoot.it/f8328e3b-99ec-4663-b783-4e4d79cd00ae",
    "coverMetadata": {
        "id": "f8328e3b-99ec-4663-b783-4e4d79cd00ae",
        "contentType": "image/*",
        "resources": "https://upload.wikimedia.org/wikipedia/commons/b/b7/SevenWondersOfTheWorld.png CC0"
    },
    "questions": [],
    "metadata": {
            "resolution": "whitelisted",
            "moderation": {
                "flaggedTimestamp": 0,
                "timestampResolution": 1570718289956,
                "resolution": "whitelisted"
            },
            "access": {
                "groupRead": [
                    "b5c71d39-c229-4eeb-8648-cd8518ec068a"
                ],
                "folderGroupIds": [],
                "features": [
                    "PremiumEduContent"
                ]
            },
            "duplicationProtection": false,
            "lastEdit": {
                "editorUserId": "4c1574ee-de54-40a2-be15-8d72b333afad",
                "editorUsername": "KahootStudio",
                "editTimestamp": 1570650888544
            }
        },
        "resources": "https://upload.wikimedia.org/wikipedia/commons/b/b7/SevenWondersOfTheWorld.png CC0",
        "slug": "seven-wonders-of-the-ancient-world",
        "languageInfo": {
            "language": "en-US",
            "lastUpdatedOn": 1655642141228,
            "readAloudSupported": true
        },
        "inventoryItemIds": [],
        "isValid": true,
        "type": "quiz",
        "created": 1527169083018,
        "modified": 1655642141349
}
"""#.data(using: .utf8) ?? Data()

class QuizTests: XCTestCase {
    
    let testDecoder = JSONDecoder()

    func testQuizDecoding() throws {
        let entity = try testDecoder.decode(Quiz.self, from: quizJsonData)
        XCTAssertEqual(entity.title, "Seven Wonders of the Ancient World")
        XCTAssertEqual(entity.description, "A #geography #quiz about the #Seven #Wonders of the #Ancient #World. See how much you know about these ancient buildings and monuments!\n#trivia #history #studio")
        XCTAssertEqual(entity.cover, URL(string: "https://media.kahoot.it/f8328e3b-99ec-4663-b783-4e4d79cd00ae"))
        XCTAssertTrue(entity.questions.isEmpty)
    }
}
