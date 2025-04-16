//
//  TriviaStart.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import SwiftUI

struct TriviaStart: View {
    @State private var numberOfQuestions: Int = 10
    @State private var sliderValue: Float = 0.0
    @State private var selectedCategory: String = "Any Category"
    @State private var selectedDifficulty: String = "Any Difficulty"
    @State private var selectedType: String = "Any Type"
    @State private var selectedDuration: String = "30 seconds"
    @State var showGame: Bool = false

    private let difficulties: [String] = ["Any Difficulty", "Easy", "Medium", "Hard"]
    private let durations: [String] = ["30 seconds", "60 seconds", "120 seconds", "300 seconds", "1 hour"]

    private let typeMap: [String: String] = [
        "Any Type" : "",
        "Multiple Choice" : "multiple",
        "True/False" : "boolean"
    ]

    private let categoryMap: [String: Int] = [
        "Any Category" : -1,
        "General Knowledge" : 9,
        "Entertainment: Books" : 10,
        "Entertainment: Film" : 11,
        "Entertainment: Music" : 12,
        "Entertainment: Musicals & Theatres" : 13,
        "Entertainment: Television" : 14,
        "Entertainment: Video Games" : 15,
        "Entertainment: Board Games" : 16,
        "Entertainment: Comics" : 29,
        "Entertainment: Japanese Anime & Manga" : 31,
        "Entertainment: Cartoon & Animations" : 32,
        "Science & Nature" : 17,
        "Science: Computers" : 18,
        "Science: Mathematics" : 19,
        "Science: Gadgets" : 30,
        "Mythology" : 20,
        "Sports" : 21,
        "Geography" : 22,
        "History" : 23,
        "Politics" : 24,
        "Art" : 25,
        "Celebrities" : 26,
        "Animals" : 27,
        "Vehicles" : 28
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                settings
                startButton
            }
            .navigationBarTitle("Trivia Game", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Trivia Game")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(TriviaTheme.backgroundColor, for: .navigationBar)
            .background(TriviaTheme.backgroundColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var startButton: some View {
        Button(action: {
            showGame = true
        }) {
            Text("Start Trivia")
                .font(.system(size: 26))
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .padding()
                .background(TriviaTheme.buttonColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .navigationDestination(isPresented: $showGame) {
            TriviaCore(
                numberOfQuestions: Int(numberOfQuestions),
                category: categoryURL(),
                difficulty: difficultyURL(),
                type: typeURL(),
                duration: convertDuration(selectedDuration)
            )
        }
    }

    private var settings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .padding(.vertical, 5)

            Stepper(value: $numberOfQuestions, in: 1...50, step: 1) {
                TextField("Number of Questions", value: $numberOfQuestions, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .font(.system(size: 19))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading) {
                Text("Category")
                    .font(.system(size: 19))
                    .foregroundColor(.white)

                Picker("Category", selection: $selectedCategory) {
                    let keys = Array(categoryMap.keys).sorted { categoryMap[$0]! < categoryMap[$1]! }
                    ForEach(keys, id: \.self) { key in
                        Text(key).foregroundColor(.white)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.white)
            }

            HStack(spacing: 12) {
                Text("\(difficulties[Int(sliderValue)])")
                    .font(.system(size: 19))
                    .foregroundColor(.white)
                    .frame(width: 102, alignment: .leading)
                Slider(value: $sliderValue, in: 0...3, step: 1)
                    .accentColor(.white)
            }

            VStack(alignment: .leading) {
                Text("Type")
                    .font(.system(size: 19))
                    .foregroundColor(.white)

                Picker("Type", selection: $selectedType) {
                    let sortedTypes = Array(typeMap.keys).sorted { typeMap[$0]! < typeMap[$1]! }
                    ForEach(sortedTypes, id: \.self) { type in
                        Text(type).foregroundColor(.white)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.white)
            }

            VStack(alignment: .leading) {
                Text("Timer Duration")
                    .font(.system(size: 19))
                    .foregroundColor(.white)

                Picker("Timer Duration", selection: $selectedDuration) {
                    ForEach(durations, id: \.self) { duration in
                        Text(duration).foregroundColor(.white)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.white)
            }
        }
        .padding()
    }

    private func convertDuration(_ duration: String) -> Int {
        switch duration {
            case "30 seconds": return 30
            case "60 seconds": return 60
            case "120 seconds": return 120
            case "300 seconds": return 300
            case "1 hour": return 3600
            default: return 30
        }
    }

    private func typeURL() -> String {
        selectedType == "Any Type" ? "" : "&type=\(typeMap[selectedType]!)"
    }

    private func difficultyURL() -> String {
        selectedDifficulty == "Any Difficulty" ? "" : "&difficulty=\(selectedDifficulty.lowercased())"
    }

    private func categoryURL() -> String {
        let categoryID = categoryMap[selectedCategory]
        return categoryID == -1 ? "" : "&category=\(categoryID!)"
    }
}
