//
//  TriviaQuestionCard.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import SwiftUI

struct TriviaQuestionCard: View {
    let triviaQuestion: TriviaQuestion
    @Binding var selectedAnswer: String?

    var body: some View {
        ZStack {
            overlayView
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 2)
                )
                .background(TriviaTheme.buttonColor)
                .cornerRadius(20)
                .padding(5)
        }
    }

    private var overlayView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(triviaQuestion.question)
                .font(.system(size: 26))
                .padding(4)

            let answers = triviaQuestion.answers
            ForEach(0..<answers.count, id: \.self) { index in
                TriviaAnswerTile(title: answers[index], selectedAnswer: $selectedAnswer)
                    .padding(4)
                    .font(.system(size: 24))
                    .onTapGesture {
                        selectedAnswer = answers[index]
                    }
            }
        }
    }
}
