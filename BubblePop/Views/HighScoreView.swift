//
//  HighScoreView.swift
//  BubblePop
//
//  Created by Sarah on 18/4/2026.
//

import SwiftUI

struct HighScoreView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        Label("High Score", systemImage: "").foregroundStyle(.red).font(.title)
        Spacer()
    }
}

#Preview {
    HighScoreView(viewModel: ViewModel())
}
