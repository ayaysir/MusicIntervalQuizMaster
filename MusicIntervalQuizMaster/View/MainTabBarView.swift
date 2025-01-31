//
//  MainTabBarView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct MainTabBarView: View {
  @State private var selectedIndex = 0
  @StateObject var statsViewModel = StatsViewModel()
  
  @AppStorage(.moreInfoRemindeIsOn) var isReminderOn: Bool = false
  @AppStorage(.moreInfoReminderHour) var reminderHour: Int = 0
  @AppStorage(.moreInfoReminderMinute) var reminderMinute: Int = 0
  
  var body: some View {
    TabView(selection: $selectedIndex) {
      QuizView()
        .tabItem {
          Label("tab_drill".localized, systemImage: "greetingcard")
        }
        .tag(0)
      StatsView(viewModel: statsViewModel)
        .tabItem {
          Label("tab_stats".localized, systemImage: "chart.bar.xaxis")
        }
        .tag(1)
      SettingView()
        .tabItem {
          Label("tab_settings".localized, systemImage: "gearshape.fill")
        }
        .tag(2)
      MoreInfoView()
        .tabItem {
          Label("tab_moreinfo".localized, systemImage: "info.circle.fill")
        }
        .tag(3)
    }
    .onAppear {
      DispatchQueue.global(qos: .background).async {
        if isReminderOn {
          LocalNotiManager.shared.removeAllNoti()
          LocalNotiManager.shared.scheduleNoti(hour: reminderHour, minute: reminderMinute)
        }
      }
    }
    .onChange(of: selectedIndex) { newValue in
      if newValue == 1 {
        statsViewModel.fetchStats()
        print("StatsViewModel refreshed!")
      }
    }
  }
}

#Preview {
  MainTabBarView(statsViewModel: .init(cdManager: QuizSessionManager(context: PersistenceController.preview.container.viewContext)))
}
