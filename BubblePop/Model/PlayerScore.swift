//
//  PlayerScore.swift
//  BubblePop
//
//  Created by Sarah on 21/4/2026.
//

import Foundation

struct PlayerScore: Codable, Identifiable {
    var id = UUID()
    var name: String
    var score: Int
}
