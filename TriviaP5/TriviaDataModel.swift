//
//  TriviaDataModel.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import Foundation

struct TriviaResponse: Codable {
    let results: [Trivia]
    let response_code: Int
}

struct Trivia: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let difficulty: String
    let correct_answer: String
    let incorrect_answers: [String]
    let type: String
    let category: String
    let question: String
}
