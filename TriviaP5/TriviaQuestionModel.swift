//
//  TriviaQuestionModel.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import Foundation

struct TriviaQuestion: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let question: String
    var answers: [String]
    let correct_answer: String
}
