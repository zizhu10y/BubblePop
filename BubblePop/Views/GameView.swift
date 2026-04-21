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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Label("Game started!", systemImage: "").foregroundStyle(.purple).font(.title)
        Spacer()
        ZStack {
            HStack {
                Text("Time Left: \(Int(viewModel.timeRemaining))")
                Text("Score: \(viewModel.score)")
            }
            .onAppear {
                viewModel.timeRemaining = viewModel.gameTime
            }
            .onReceive(timer) { _ in
                if viewModel.gameTime > 0 {
                    viewModel.gameTime -= 1
                } else {
                        // Game Over Trigger
                }
            }
        }
    }
}

#Preview {
    GameView(viewModel: ViewModel())
}
