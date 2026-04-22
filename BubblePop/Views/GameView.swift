//
//  GameView.swift
//  BubblePop
//
//  Created by Sarah on 17/4/2026.
//

import SwiftUI
import Combine

struct GameView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var playerName = ""
    @State private var isGameFinished: Bool = false
    @State private var scoreSaved = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func saveScore() {
        //Fetch the existing array of data from UserDefaults
        var currentScores: [PlayerScore] = []
        if let savedData = UserDefaults.standard.data(forKey: "leaderboardKey"){
            if let decoded = try? JSONDecoder().decode([PlayerScore].self, from: savedData) {
                currentScores = decoded
            }
            
        }
        // 2. Append the new score
        let newScore = PlayerScore(name: playerName, score: viewModel.score)
        currentScores.append(newScore)
        
        // 3. Encode the updated array back into raw Data and overwrite UserDefaults
        if let encoded = try? JSONEncoder().encode(currentScores) {
            UserDefaults.standard.set(encoded, forKey: "leaderboardKey")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.bubbles) { bubble in
                    Circle()
                        .fill(bubble.type.color)
                        .frame(width: 80, height: 80)
                        .position(x: bubble.x, y: bubble.y)
                        .onTapGesture {
                            viewModel.score += bubble.type.points
                            viewModel.bubbles.removeAll { $0.id == bubble.id}
                        }
                }
                VStack {
                    Label("Game started!", systemImage: "").foregroundStyle(.purple).font(.title)
                    
                    HStack {
                        Spacer()
                        Text("Time Left: \(Int(viewModel.timeRemaining))")
                        Spacer()
                        Text("\(playerName)")
                        Spacer()
                        Text("Score: \(viewModel.score)")
                        Spacer()
                    }
                    Spacer()
                    Button("Finish Game"){
                        scoreSaved = true
                        //随机一个
                        viewModel.timeRemaining = 0
                        viewModel.score = Int.random(in: 0...100)
                        saveScore()
                        isGameFinished = true
                    }
                }
                .onAppear {
                    viewModel.timeRemaining = viewModel.gameTime
                    playerName = UserDefaults.standard.string(forKey: "savedAppUser") ?? ""
                    viewModel.generateBubbles(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                }
                .onReceive(timer) { _ in
                    if viewModel.timeRemaining > 0 {
                        viewModel.timeRemaining -= 1
                        viewModel.refreshBubbles(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                    } else if !isGameFinished{
                        scoreSaved = true
                        //随机一个
                        viewModel.score = Int.random(in: 0...100)
                        saveScore()
                        isGameFinished = true
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $isGameFinished, content: {
            HighScoreView()
        })
        
    }
}

#Preview {
    GameView(viewModel: ViewModel())
}
