//
//  TriviaTheme.swift
//  TriviaP5
//
//  Created by Julio Varela on 4/15/25.
//
import SwiftUI

struct TriviaTheme {
    static let buttonColor: LinearGradient = LinearGradient(
        colors: [.black.opacity(0.9), .gray.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let foregroundColor: Color = .white
    //static let foregroundColor: Color.Shape = .white.opacity.(0.0)
    //statoc let background color: Color.Shape = .white
    static let backgroundColor: Color = .black
    //static let settingsColor: Color.Shape = .black.opacity(0)
    //static let accentColor: Color.Shape = .gray()
    static let settingsColor: Color = .gray.opacity(0.3)
    static let accentColor: Color = .white
}
