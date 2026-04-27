//
//  SettingsView.swift
//  BubblePop
//
// Finished by Zizhu on 24/4/2026.
//

import SwiftUI
struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var playerName: String = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors:[
                Color(red: 0.85, green: 0.93, blue: 1.0),
                Color(red: 1.0, green: 0.88, blue: 0.93)
            ] , startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 20){
                Text("Settings")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 1.0, green: 0.5, blue: 0.7)], startPoint: .leading, endPoint: .trailing)).padding(.top)
                Spacer()
                VStack (alignment: .leading, spacing: 8){
                    Text("Enter Your Name:")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.gray)
                    TextField("Enter Name", text: $playerName)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 16, design: .rounded))
                }
                .padding(.horizontal)
                Spacer()
                
                VStack(spacing: 8) {
                    //Time setter here
                    Text("Game Time: \(Int(viewModel.gameTime)) seconds")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    Slider(value: $viewModel.gameTime, in: 10...110, step: 1)
                        .tint(Color(red: 0.4, green: 0.6, blue: 1.0))
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                VStack(spacing: 8) {
                    //bubble setter
                    Text("Max bubbles: \(Int(viewModel.numberOfBubbles))")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    Slider(value: $viewModel.numberOfBubbles, in: 1...29, step: 1)
                        .tint(Color(red: 0.4, green: 0.6, blue: 1.0))
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: GameView(viewModel: viewModel)){
                    Text("Start Game")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 220, height: 55)
                        .background(
                            playerName.isEmpty ? AnyShapeStyle(Color.gray.opacity(0.4)) : AnyShapeStyle(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 1.0, green: 0.5, blue: 0.7)], startPoint: .leading, endPoint: .trailing))
                        )
                        .clipShape(Capsule())
                        .shadow(color: playerName.isEmpty ? .clear : .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .disabled(playerName.isEmpty)
                .simultaneousGesture(TapGesture().onEnded{
                    UserDefaults.standard.set(playerName, forKey: "savedAppUser")
                })
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: GameViewModel())
}
