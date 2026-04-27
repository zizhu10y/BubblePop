//
//  PlayerScore.swift
//  BubblePop
//
// Finished by Zizhu on 24/4/2026.
//

import Foundation

// Represents a play's name and their high score
struct PlayerScore: Codable, Identifiable {
    var id = UUID()
    var name: String
    var score: Int
}
