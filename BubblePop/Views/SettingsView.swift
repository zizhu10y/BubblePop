//
//  SettingsView.swift
//  BubblePop
//
//  Created by Sarah on 17/4/2026.
//

import SwiftUI
//the system requirements dictate user configuration before starting gameplay
struct SettingsView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var playerName: String = ""
    
    var body: some View {
        
        VStack {
            Label("Settings", systemImage: "")
                .foregroundStyle(.green)
                .font(.title)
            Spacer()
            Text("Enter Your Name:")
            
            TextField("Enter Name", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .padding()
            Spacer()
            
            //Time setter here
            Text("Game Time: \(Int(viewModel.gameTime)) seconds")
            Slider(value: $viewModel.gameTime, in: 0...60, step: 1)
                .padding()
            //bubble setter
            Text("Max bubbles: \(Int(viewModel.numberOfBubbles))")
                .padding()
            Slider(value: $viewModel.numberOfBubbles, in: 1...15, step: 1)
                .padding()
            
            NavigationLink(destination: GameView(viewModel: viewModel)){
                Text("Start Game")
                    .padding()
            }
            .disabled(playerName.isEmpty)
            .simultaneousGesture(TapGesture().onEnded{
                UserDefaults.standard.set(playerName, forKey: "savedAppUser")
            })
            Spacer()
        }
    }
}

#Preview {
    SettingsView(viewModel: ViewModel())
}
