//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by iOS Dev Ninja on 15/12/2024.
//

import SwiftUI

struct ContentView: View {
    let picks = ["✊🏻", "✋🏻", "✌🏻"]
    let winPicks = ["✋🏻", "✌🏻", "✊🏻"]
    @State private var randomI = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var isWin = false
    @State private var selection = "？"
    
    @State private var showingScore = false
    @State private var gameCount = 0
    let endCount = 5
    
    @State private var isTap = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo, .black], startPoint: .top, endPoint: .bottom)
            VStack(spacing: 30) {
                Text("Rock, Paper, Scissors")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text(picks[randomI])
                    .font(.system(size: 200))
                    .rotationEffect(.degrees(180))
                    .rotation3DEffect(
                        .degrees(isTap ? 720 : 0),
                        axis: (x:0, y:1, z:0)
                    )
                    .animation(.easeInOut(duration: 0.8), value: isTap)
                ScoreView(score: score, isWin: isWin, gameCount: gameCount)
                    .padding(.horizontal)
                Text(selection)
                    .font(.system(size: 200))
                    .foregroundStyle(.white)
                
                HStack(spacing: 60) {
                    ForEach(0..<winPicks.count) { num in
                        Button(winPicks[num]) {
                            tapped(num: num)
                            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                                nextRound()
                            }
                        }
                        .font(.system(size: 60))
                        .background(selection == winPicks[num] ? .indigo : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(.indigo.opacity(0.3))
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding()
            .padding(.top, 50)
        }
        .ignoresSafeArea()
        .alert("End Game. Score \(score)", isPresented: $showingScore) {
            Button("Restart", action: reset)
        }
    }
    
    func tapped(num: Int) {
        selection = winPicks[num]
        isTap.toggle()

        isWin = num == randomI ? true : false
        score += isWin ? 30 : -10
        
        gameCount += 1
        if gameCount == endCount {
            showingScore = true
        }
    }
    func nextRound() {
        randomI = Int.random(in: 0...2)
        selection = "？"
    }
    func reset() {
        randomI = Int.random(in: 0...2)
        selection = "？"
        score = 0
        gameCount = 0
    }
    func winningMove(for move: Int) -> Int {
        // ["Rock", "Paper", "Scissors"] => ["Paper", "Scissors", "Rock"]
        return (move + 1) % 3
    }
    
}

struct ScoreView: View {
    let score: Int
    let isWin: Bool
    let gameCount: Int
    
    var body: some View {
        HStack(spacing: 50) {
            Text(gameCount != 0 ? isWin ? "Win" : "Lose" : "")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Spacer()
            Text("Score \(score)")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
        }
    }
}


#Preview {
    ContentView()
}
