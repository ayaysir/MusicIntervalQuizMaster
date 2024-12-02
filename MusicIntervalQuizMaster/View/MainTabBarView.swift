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
          Label("tab_drill".localized, systemImage: "greetingcard")
        }
      StatsView()
        .tabItem {
          Label("tab_stats".localized, systemImage: "chart.bar.xaxis")
        }
      SettingView()
        .tabItem {
          Label("tab_settings".localized, systemImage: "gearshape.fill")
        }
      MoreInfoView()
        .tabItem {
          Label("tab_moreinfo".localized, systemImage: "info.circle.fill")
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
