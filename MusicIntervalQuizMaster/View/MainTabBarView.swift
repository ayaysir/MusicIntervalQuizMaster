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
      StatsView()
        .tabItem {
          Label("Statistics", systemImage: "chart.bar.xaxis")
        }
      SettingView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.fill")
        }
      MoreInfoView()
        .tabItem {
          Label("More Info", systemImage: "info.circle.fill")
        }
    }
    .onAppear {
      // let result = QuestionRecordEntityHelper().fetchSessionRecordsGroupedByUUID()
      // print("fetchSessionRecordsGroupedByUUID():", result)
    }
  }
}

#Preview {
  MainTabBarView()
}
