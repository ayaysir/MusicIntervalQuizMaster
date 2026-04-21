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
  
  @State private var pair: IntervalPair?
  
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
      AppSettingView()
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
      
      NotificationDelegate.shared.onReceive = { userInfo in
        print("received notification!")
        handleLocalNotiUserInfo(userInfo: userInfo)
      }
      
      // cold start 대응
      if let pending = NotificationDelegate.shared.pendingUserInfo {
        handleLocalNotiUserInfo(userInfo: pending)
        NotificationDelegate.shared.pendingUserInfo = nil
      }
    }
    .onChange(of: selectedIndex) { newValue in
      // Stat 탭을 누를때마다 데이터를 새로 불러옴 (재방문하면 onAppear가 다시 동작 안함)
      if newValue == 1 {
        statsViewModel.fetchStats()
        print("StatsViewModel refreshed!")
      }
    }
  }
  
  private func handleLocalNotiUserInfo(userInfo: [AnyHashable : Any]) {
    guard let data = userInfo[String.keyUserInfoIntervalPair] as? Data,
          let pair = try? JSONDecoder().decode(IntervalPair.self, from: data) else {
      return
    }
    
    print("received IntervalPair from notification: \(data)")
    print(" - pair: ", pair)
    
    self.pair = pair
    
    DispatchQueue.main.async {
      presentIntervalInfoWhenReady()
    }
  }
  
  private func presentIntervalInfoWhenReady() {
    if let scene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
       scene.windows.first(where: { $0.isKeyWindow }) != nil {

      if let pair {
        InstantSheet.show(hostingView: IntervalInfoView(pair: pair))
      }
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        presentIntervalInfoWhenReady()
      }
    }
  }
}

#Preview {
  let statsPreviewViewModel = StatsViewModel(
    cdManager: QuizSessionManager(
      context: PersistenceController.preview.container.viewContext
    )
  )
  MainTabBarView(statsViewModel: statsPreviewViewModel)
}
