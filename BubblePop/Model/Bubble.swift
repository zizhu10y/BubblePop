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
        case .red: return .red
        case .pink: return .pink
        case .green: return .green
        case .blue: return .blue
        case .black: return .black
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
}
