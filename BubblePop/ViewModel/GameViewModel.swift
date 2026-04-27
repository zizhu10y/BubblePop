//
//  GameViewModel.swift
//  BubblePop
//
//  Created by Sarah on 18/4/2026.
//

import Foundation
import Combine
class GameViewModel: ObservableObject {
    @Published var gameTime: Double = 60
    @Published var timeRemaining: Double = 60
    @Published var score: Int = 0
    @Published var numberOfBubbles: Double = 15
    @Published var bubbles: [Bubble] = []
    @Published var lastPoppedType: BubbleType? = nil
    
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
        var attempts = 0
        while attempts < 20 {
            let x = CGFloat.random(in: radius...(screenWidth - radius))
            let y = CGFloat.random(in: radius...(screenHeight - radius - 100))
            
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
    
    
    func refreshBubbles(screenWidth: CGFloat, screenHeight: CGFloat) {
        guard !bubbles.isEmpty else {
            generateBubbles(screenWidth: screenWidth, screenHeight: screenHeight)
            return
        }
        let removeCount = Int.random(in: 0...bubbles.count - 1)
        bubbles.shuffle()
        bubbles = Array(bubbles.dropLast(removeCount))
        
        let maxAdd = Int(numberOfBubbles) - bubbles.count
        if maxAdd > 0 {
            let addCount = Int.random(in: 1...maxAdd)
            for _ in 0..<addCount {
                if let bubble = placeBubble(screenWidth: screenWidth, screenHeight: screenHeight, existing: bubbles){
                    bubbles.append(bubble)
                }
            }
        }
        
    }
    
    func popBubble(_ bubble: Bubble) {
        let isCombo = (lastPoppedType == bubble.type)
        let points = isCombo ? Int((Double(bubble.type.points) * 1.5).rounded())
        : bubble.type.points
        score += points
        lastPoppedType = bubble.type
        if let idx = bubbles.firstIndex(where: { $0.id == bubble.id}) {
            bubbles[idx].isPopped = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            self.bubbles.removeAll{ $0.id == bubble.id}
        }
    }
    
    func moveBubbles(screenWidth: CGFloat, screenHeight: CGFloat) {
        let speedMultiplier = 1.0 + (gameTime - timeRemaining) / gameTime * 2.0
        for idx in bubbles.indices {
            bubbles[idx].y -= 10.0 * speedMultiplier
        }
        
        bubbles.removeAll {
            $0.x < radius || $0.x > screenWidth - radius || $0.y < radius || $0.y > screenHeight - radius
        }
    }
    
    func saveScore(playerName: String) {
        // Fetch the existing array of data from UserDefaults
        var currentScores: [PlayerScore] = []
        if let savedData = UserDefaults.standard.data(forKey: "leaderboardKey"){
            if let decoded = try? JSONDecoder().decode([PlayerScore].self, from: savedData) {
                currentScores = decoded
            }
            
        }
        // Append the new score
        if let idx = currentScores.firstIndex(where: { $0.name == playerName}) {
            if score > currentScores[idx].score {
                currentScores[idx].score = score
            }
        } else {
            currentScores.append(PlayerScore(name: playerName, score: score))
        }
        
        // Encode the updated array back into raw Data and overwrite UserDefaults
        if let encoded = try? JSONEncoder().encode(currentScores) {
            UserDefaults.standard.set(encoded, forKey: "leaderboardKey")
        }
    }
}
