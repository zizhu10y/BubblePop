//
//  ContentView.swift
//  BubblePop
//
//  Created by Sarah on 14/4/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                Label("Bubble Pop", systemImage: "").foregroundStyle(.mint).font(.largeTitle)
                Spacer()
                
                NavigationLink(
                    destination: SettingsView(viewModel: viewModel),
                    label: {
                        Text("New Game")
                            .font(.title)
                    } )
                .padding(50)
                
                NavigationLink(
                    destination: HighScoreView(viewModel: viewModel),
                    label: {
                        Text("High Score")
                            .font(.title)
                    } )
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
