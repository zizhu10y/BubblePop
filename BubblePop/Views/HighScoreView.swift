//
//  HighScoreView.swift
//  BubblePop
//
//  Created by Sarah on 18/4/2026.
//

import SwiftUI

struct HighScoreView: View {
    var onGoHome: (() -> Void)? = nil
    @State private var playerScores: [PlayerScore] = []
    var body: some View {
        VStack{
            Label("High Score", systemImage: "").foregroundStyle(.red).font(.title)
            List {
                ForEach(playerScores.sorted(by: { $0.score > $1.score }).prefix(5)) { player in
                    HStack {
                        Text(player.name)
                        Spacer()
                        Text("\(player.score) pts")
                    }
                }
            }
            Button("Back to Home") {
                onGoHome?()
            }
            .padding()
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
