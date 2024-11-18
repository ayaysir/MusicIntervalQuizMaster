//
//  MainTabBarView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct MainTabBarView: View {
  var body: some View {
    TabView {
      QuizView()
        .tabItem {
          Label("Quiz", systemImage: "greetingcard")
        }
      Text("StatsView")
        .tabItem {
          Label("Statistics", systemImage: "chart.bar.xaxis")
        }
      SettingView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.fill")
        }
      Text("Info & Learn")
        .tabItem {
          Label("More Info", systemImage: "info.circle.fill")
        }
    }
  }
}

#Preview {
  MainTabBarView()
}
