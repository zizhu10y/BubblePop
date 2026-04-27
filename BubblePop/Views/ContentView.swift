//
//  ContentView.swift
//  BubblePop
//
//  Created by Sarah on 14/4/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var playerName: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors:[
                    Color(red: 0.85, green: 0.93, blue: 1.0),
                    Color(red: 1.0, green: 0.88, blue: 0.93)
                ] , startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 200, height: 200)
                    .position(x: 30, y: 100)
                
                Circle()
                    .fill(Color.pink.opacity(0.15))
                    .frame(width: 150, height: 150)
                    .position(x: 350, y: 200)
                
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .position(x: 130, y: 300)
                Circle()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .position(x: 230, y: 250)
                
                VStack(spacing: 8) {
                    Text("Bubble Pop")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 1.0, green: 0.5, blue: 0.7)], startPoint: .leading, endPoint: .trailing)).padding(.top)
                    Text("🫧")
                        .font(.system(size: 60))
                    Spacer()
                    
                    NavigationLink(
                        destination: SettingsView(viewModel: viewModel),
                        label: {
                            Text("New Game")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: 220, height: 55)
                                .background(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)], startPoint: .leading, endPoint: .trailing))
                                .clipShape(Capsule())
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        } )
                    .padding(50)
                    
                    NavigationLink(
                        destination: HighScoreView(),
                        label: {
                            Text("High Score")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                                .frame(width: 220, height: 55)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Capsule())
                                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                        } )
                    Spacer()
                }
                .padding()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
