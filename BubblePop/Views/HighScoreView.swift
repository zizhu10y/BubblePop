//
//  HighScoreView.swift
//  BubblePop
//
// Finished by Zizhu on 24/4/2026.
//

import SwiftUI

struct HighScoreView: View {
    var onGoHome: (() -> Void)? = nil
    @State private var playerScores: [PlayerScore] = []
    var body: some View {
        ZStack{
            LinearGradient(colors:[
                Color(red: 0.85, green: 0.93, blue: 1.0),
                Color(red: 1.0, green: 0.88, blue: 0.93)
            ] , startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            VStack{
                Text("🏆High Score").font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 1.0, green: 0.5, blue: 0.7)], startPoint: .leading, endPoint: .trailing)).padding(.top)
                List {
                    ForEach(playerScores.sorted(by: { $0.score > $1.score }).prefix(5)) { player in
                        HStack {
                            Text(player.name)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                            Spacer()
                            Text("\(player.score) pts")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                if onGoHome != nil {
                    Button("Play again") {
                        onGoHome?()
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 220, height: 55)
                    .background(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding()
                }
            }
        }
        .onAppear {
            if let savedData = UserDefaults.standard.data(forKey: "leaderboardKey") {
                if let decoded = try? JSONDecoder().decode([PlayerScore].self, from: savedData) {
                    playerScores = decoded
                }
            }
        }
    }
}

#Preview {
    HighScoreView()
}
