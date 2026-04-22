//
//  HighScoreViewModel.swift
//  BubblePop
//
//  Created by Sarah on 18/4/2026.
//

import Foundation
import Combine
class  ViewModel: ObservableObject {
    @Published var gameTime: Double = 60
    @Published var timeRemaining: Double = 60
    @Published var score: Int = 0
    @Published var numberOfBubbles: Double = 15
    @Published var bubbles: [Bubble] = []
    
    let radius: CGFloat = 40
    
    //Choose bubble based on cumulative
    func randomBubbleType() -> BubbleType {
        let random = Double.random(in: 0...1)
        var cumulative = 0.0
        for type in BubbleType.allCases {
            cumulative += type.probability
            if random < cumulative {
                return type
            }
        }
        return .red
    }
    
    func placeBubble(screenWidth: CGFloat, screenHeight: CGFloat, existing: [Bubble]) -> Bubble? {
        let radius: CGFloat = 40
        var attempts = 0
        while attempts < 20 {
            let x = CGFloat.random(in: radius...(screenWidth - radius))
            let y = CGFloat.random(in: (radius + 50.0)...(screenHeight - radius - 100.0))
            
            let overlaps = existing.contains { bubble in
                let dx = bubble.x - x
                let dy = bubble.y - y
                return sqrt(dx*dx + dy*dy) < radius * 2
            }
            if !overlaps {
                return Bubble(x: x, y: y, type: randomBubbleType())
            }
            attempts += 1
        }
        return nil
    }
    
    func generateBubbles(screenWidth: CGFloat, screenHeight: CGFloat) {
        var newBubbles: [Bubble] = []
        
        for _ in 0..<Int(numberOfBubbles) {
            if let bubble = placeBubble(screenWidth: screenWidth, screenHeight: screenHeight, existing: newBubbles){
                newBubbles.append(bubble)
            }
        }
        bubbles = newBubbles
    }
    
    //need to change
    func refreshBubbles(screenWidth: CGFloat, screenHeight: CGFloat) {
        let removeCount = Int.random(in: 0...bubbles.count)
        bubbles = Array(bubbles.dropLast(removeCount))
        let maxAdd = Int(numberOfBubbles) - bubbles.count
        let addCount = Int.random(in: 0...maxAdd)
        for _ in 0..<addCount {
            if let bubble = placeBubble(screenWidth: screenWidth, screenHeight: screenHeight, existing: bubbles){
                bubbles.append(bubble)
            }
        }
    }
}
