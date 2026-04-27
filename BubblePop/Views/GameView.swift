//
//  GameView.swift
//  BubblePop
//
// Finished by Zizhu on 24/4/2026.
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
        ZStack{
            LinearGradient(colors:[
                Color(red: 0.85, green: 0.93, blue: 1.0),
                Color(red: 1.0, green: 0.88, blue: 0.93)
            ] , startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Text("🫧Bubble Pop")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 1.0, green: 0.5, blue: 0.7)], startPoint: .leading, endPoint: .trailing))
                HStack {
                    Spacer()
                    VStack {
                        Text("Time")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.gray)
                        Text("\(Int(viewModel.timeRemaining))")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                    }
                    Spacer()
                    VStack {
                        Text("Player")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.gray)
                        Text(playerName)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    VStack {
                        Text("Score")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.gray)
                        Text("\(viewModel.score)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.7))
                    }
                    Spacer()
                    VStack {
                        Text("Best")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.gray)
                        Text("\(bestScore)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 1.0))
                    }
                    Spacer()
                    Button{
                        if !scoreSaved {
                            timerActive = false
                            scoreSaved = true
                            viewModel.saveScore(playerName: playerName)
                            isGameFinished = true
                        }
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: "flag.checkered.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.pink)
                            Text("End")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.pink)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(viewModel.bubbles) { bubble in
                            ZStack {
                                Circle()
                                    .fill(bubble.type.color)
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .stroke(Color.white.opacity(0.6), lineWidth: 3)
                                    .frame(width: 80, height: 80)
                                Text("\(bubble.type.points)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(bubble.isPopped ? 0 : 1)
                            .animation(.easeOut(duration: 0.16), value: bubble.isPopped)
                            .position(x: bubble.x, y: bubble.y)
                            .onTapGesture {
                                viewModel.popBubble(bubble)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
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
        }
        .onReceive(timer) { _ in
            guard timerActive else {return}
            if viewModel.timeRemaining > 0 {
                viewModel.timeRemaining -= 1
                viewModel.moveBubbles(screenWidth: screenSize.width, screenHeight: screenSize.height)
                viewModel.refreshBubbles(screenWidth: screenSize.width, screenHeight: screenSize.height)
            } else if !isGameFinished{
                timerActive = false
                scoreSaved = true
                viewModel.saveScore(playerName: playerName)
                isGameFinished = true
            }
        }
        .sheet(isPresented: $isGameFinished) {
            HighScoreView(onGoHome: {
                isGameFinished = false
                dismiss()
            })
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
