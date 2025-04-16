//
//  TriviaService.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import SwiftUI
import Foundation

enum TriviaService {
    static func fetch(from urlString: String, completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) async {
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)

            let questions: [TriviaQuestion] = triviaResponse.results.map { trivia in
                var combinedAnswers = trivia.incorrect_answers.map { $0.htmlDecoded }
                combinedAnswers.append(trivia.correct_answer.htmlDecoded)
                combinedAnswers.shuffle()

                return TriviaQuestion(
                    question: trivia.question.htmlDecoded,
                    answers: combinedAnswers,
                    correct_answer: trivia.correct_answer.htmlDecoded
                )
            }

            completion(.success(questions))
        } catch {
            completion(.failure(error))
        }
    }
}

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string

        return decoded ?? self
    }
}
