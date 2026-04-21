//
//  HighScoreViewModel.swift
//  BubblePop
//
//  Created by Sarah on 18/4/2026.
//

import Foundation
import Combine
class  ViewModel: ObservableObject {
    @Published var playerName: String = ""
    @Published var gameTime: Double = 60
    @Published var timeRemaining: Double = 60
    @Published var score: Int = 0
    @Published var numberOfBubbles: Double = 15
    @Published var bubbles: [Bubble] = []
    
    enum BubbleType{
        case red, pink, green, blue, black
        

    }
}
