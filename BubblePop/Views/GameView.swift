//
//  GameView.swift
//  BubblePop
//
//  Created by Sarah on 17/4/2026.
//

import SwiftUI
import Combine

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GameViewModel
    @State private var playerName = ""
    @State private var bestScore: Int = 0
    @State private var isGameFinished: Bool = false
    @State private var scoreSaved = false
    @State private var screenSize: CGSize = .zero
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timerActive = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.bubbles) { bubble in
                    Circle()
                        .fill(bubble.type.color)
                        .frame(width: 80, height: 80)
                        .scaleEffect(bubble.isPopped ? 0 : 1)
                        .animation(.easeOut(duration: 0.16), value: bubble.isPopped)
                        .position(x: bubble.x, y: bubble.y)
                        .onTapGesture {
                            viewModel.popBubble(bubble)
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
                        Text("Best: \(bestScore)")
                        Spacer()
                    }
                    Spacer()
                    Button("Finish Game"){
                        if !scoreSaved {
                            timerActive = false
                            scoreSaved = true
                            viewModel.saveScore(playerName: playerName)
                            isGameFinished = true
                        }
                    }
                }
                .onAppear {
                    screenSize = geometry.size
                    viewModel.timeRemaining = viewModel.gameTime
                    viewModel.score = 0
                    viewModel.lastPoppedType = nil
                    playerName = UserDefaults.standard.string(forKey: "savedAppUser") ?? ""
                    viewModel.generateBubbles(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                    timerActive = true
                    
                    if let savedData = UserDefaults.standard.data(forKey: "leaderboardKey"),
                       let decoded = try? JSONDecoder().decode([PlayerScore].self, from: savedData) {
                        bestScore = decoded.map { $0.score }.max() ?? 0
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            guard timerActive else {return}
            if viewModel.timeRemaining > 0 {
                viewModel.timeRemaining -= 1
                viewModel.refreshBubbles(screenWidth: screenSize.width, screenHeight: screenSize.height)
            } else if !isGameFinished{
                timerActive = false
                scoreSaved = true
                viewModel.saveScore(playerName: playerName)
                isGameFinished = true
            }
        }
        .padding()
        .sheet(isPresented: $isGameFinished) {
            HighScoreView(onGoHome: {
                isGameFinished = false
                dismiss ()
            })
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
