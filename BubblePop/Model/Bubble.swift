//
//  Bubble.swift
//  BubblePop
//
//  Created by Sarah on 21/4/2026.
//

import Foundation

enum BubbleType: String, Codable, CaseIterable{
    case red, pink, green, blue, black
}

struct Bubble: Codable, Identifiable {
    var id = UUID()
    var x: CGFloat
    var y: CGFloat
    var type: BubbleType
    var points: Int
}
