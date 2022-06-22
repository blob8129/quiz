//
//  QuizLoader.swift
//  Quiz
//
//  Created by Andrey Volobuev on 20/06/2022.
//

import Foundation

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
            let (data, _) = try await URLSession.shared.data(from: url)
            return try decoder.decode(Quiz.self, from: data)
        case .local(let data):
            return try decoder.decode(Quiz.self, from: data)
        }
    }
    
    init(source: Source, decoder: JSONDecoder = JSONDecoder()) {
        self.sources = [source]
        self.decoder = decoder
    }
}
