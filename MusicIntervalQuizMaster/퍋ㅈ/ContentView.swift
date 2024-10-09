//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var gameCenterViewModel = GameCenterViewModel()
  @State private var showDashboard = false
  
  var body: some View {
    VStack {
      if gameCenterViewModel.isAuthenticated {
        Text("Game Center 인증 성공")
        Button(action: {
          showDashboard.toggle()
        }) {
          Text("Game Center 대시보드 열기")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        Text("Game Center 업적")
          .font(.largeTitle)
        
        List(gameCenterViewModel.achievements, id: \.identifier) { achievement in
          VStack(alignment: .leading) {
            Text(achievement.identifier)
              .font(.headline)
            Text("달성률: \(achievement.percentComplete)%")
          }
        }
        
        Button(action: {
          // 예시로 업적 달성 100%, 스코어 932점 보고
          gameCenterViewModel.reportAchievement(identifier: "achivement_perfect_10", percentComplete: 100.0)
          gameCenterViewModel.reportScore(leaderboardID: "leaderboard_totalscore", score: 932)
        }) {
          Text("업적 달성 100%, 스코어 932점 보고")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }
    }
    .onAppear {
      gameCenterViewModel.authenticateUser()
    }
    .fullScreenCover(isPresented: $showDashboard) {
      GameCenterDashboardRepresentedView()
    }
  }
}

#Preview {
  ContentView()
}
