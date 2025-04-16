//
//  TriviaCore.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import SwiftUI
import Combine

struct TriviaCore: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedAnswers: [String?]
    @State private var trivias: [Trivia] = []
    //@State private var OGtrivias: [OGTrivia] = []
    @State private var triviaQuestions: [TriviaQuestion] = []
    @State private var isLoading: Bool = false
    @State private var score = 0
    @State private var showAlert = false
    @State private var timeRemaining: Int

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let numberOfQuestions: Int
    let category: String
    let difficulty: String
    let type: String
    let duration: Int
    // Db connec
    private var API_URL: String {
        "https://opentdb.com/api.php?amount=\(numberOfQuestions)\(category)\(difficulty)\(type)"
    }

    init(numberOfQuestions: Int, category: String, difficulty: String, type: String, duration: Int) {
        self.numberOfQuestions = numberOfQuestions
        self.category = category
        self.difficulty = difficulty
        self.type = type
        self.duration = duration

        _timeRemaining = State(initialValue: duration)
        _selectedAnswers = State(initialValue: Array(repeating: nil, count: numberOfQuestions))
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Trivia...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding()
            } else {
                if triviaQuestions.isEmpty {
                    Text("Questions still loading or unavailable.\nPlease wait or try again.")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    showTimer
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            questions
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            timer.upstream.connect().cancel()
                            calculateScore()
                            showAlert = true
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Score"),
                            message: Text("You scored \(score) out of \(numberOfQuestions)"),
                            dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            })
                        )
                    }
                    submitButton
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TriviaTheme.backgroundColor)
        .onAppear {
            Task {
                isLoading = true
                await TriviaService.fetch(from: API_URL) { result in
                    switch result {
                    case .success(let transformed):
                        self.triviaQuestions = transformed
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self.isLoading = false
                }
            }
        }
    }

    private func calculateScore() {
        var i = 0
        while i < triviaQuestions.count {
            if selectedAnswers.indices.contains(i),
               let selectedAnswer = selectedAnswers[i],
               selectedAnswer == triviaQuestions[i].correct_answer {
                score += 1
            }
            i += 1
        }
    }

    private var questions: some View {
        ForEach(triviaQuestions.indices, id: \.self) { index in
            TriviaQuestionCard(
                triviaQuestion: triviaQuestions[index],
                selectedAnswer: $selectedAnswers[index]
            )
            .foregroundColor(.white)
        }
        .font(.system(size: 22))
    }

    private var showTimer: some View {
        Text("Time Remaining: \(timeRemaining)s")
            .font(.system(size: 24, weight: .semibold))
            .padding(.top)
            .foregroundColor(timeRemaining > 10 ? .white : .red)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var submitButton: some View {
        Button(action: {
            calculateScore()
            showAlert = true
        }) {
            Text("Submit")
                .font(.system(size: 26, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .padding()
                .background(TriviaTheme.buttonColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(timeRemaining == 0)
    }
}

