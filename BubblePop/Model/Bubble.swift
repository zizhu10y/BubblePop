//
//  Bubble.swift
//  BubblePop
//
//  Created by Sarah on 21/4/2026.
//

import Foundation
import SwiftUI

enum BubbleType: String, Codable, CaseIterable{
    case red, pink, green, blue, black
    
    var color: Color {
        switch self {
        case .red: return Color(red: 1.0, green: 0.2, blue: 0.2)
        case .pink: return Color(red: 1.0, green: 0.5, blue: 0.8)
        case .green: return Color(red: 0.2, green: 0.8, blue: 0.3)
        case .blue: return Color(red: 0.2, green: 0.4, blue: 1.0)
        case .black: return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }
    
    var points: Int {
        switch self {
        case .red: return 1
        case .pink: return 2
        case .green: return 5
        case .blue: return 8
        case .black: return 10
        }
    }
    
    var probability: Double {
        switch self {
        case .red: return 0.40
        case .pink: return 0.30
        case .green: return 0.15
        case .blue: return 0.10
        case .black: return 0.05
            
        }
    }
}

struct Bubble: Codable, Identifiable {
    var id = UUID()
    var x: CGFloat
    var y: CGFloat
    var type: BubbleType
    var isPopped: Bool = false
    var dx: CGFloat = CGFloat.random(in: -2...2)
    var dy: CGFloat = CGFloat.random(in: -2...2)
}
