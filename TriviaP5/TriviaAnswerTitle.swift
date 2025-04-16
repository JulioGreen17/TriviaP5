//
//  TriviaAnswerTitle.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//

import SwiftUI

struct TriviaAnswerTile: View {
    @State var title: String
    @Binding var selectedAnswer: String?

    var body: some View {
        HStack {
            Image(systemName: title == selectedAnswer ? "checkmark.circle.fill" : "circle")
                .foregroundColor(title == selectedAnswer ? TriviaTheme.accentColor : .white)
                .onTapGesture {
                    self.selectedAnswer = self.title
                }

            Text(title)
            Spacer()
        }
    }
}
