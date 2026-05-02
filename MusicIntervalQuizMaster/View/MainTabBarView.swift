//
//  MainTabBarView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct MainTabBarView: View {
  @StateObject var statsViewModel: StatsViewModel
  
  @State private var selectedIndex = 0
  
  @AppStorage(.moreInfoRemindeIsOn) var isReminderOn: Bool = false
  @AppStorage(.moreInfoReminderHour) var reminderHour: Int = 0
  @AppStorage(.moreInfoReminderMinute) var reminderMinute: Int = 0
  
  @State private var pair: IntervalPair?
  
#if LITE_VERSION
  private var appOpenAdManager = AppOpenAdManager()
  @Environment(\.scenePhase) var scenePhase
  @State private var isFirstRun = true
  @State private var lastAdShownDate: Date? = nil
#endif
  
  private let STATS_TAG = 1
  
  init(statsViewModel: StatsViewModel = StatsViewModel()) {
    _statsViewModel = StateObject(wrappedValue: statsViewModel)
  }
  
  var body: some View {
    TabView(selection: $selectedIndex) {
      QuizView()
        .tabItem {
          Label("tab_drill".localized, systemImage: "greetingcard")
        }
        .tag(0)
      LearnStudyMainView()
        .tabItem {
          Label("tab_learn".localized, systemImage: "graduationcap.fill")
        }
        .tag(4)
      StatsView(viewModel: statsViewModel)
        .tabItem {
          Label("tab_stats".localized, systemImage: "chart.bar.xaxis")
        }
        .tag(STATS_TAG)
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
      
#if LITE_VERSION
      isFirstRun = false
#endif
    }
    .onChange(of: selectedIndex) { newValue in
      // Stat 탭을 누를때마다 데이터를 새로 불러옴 (재방문하면 onAppear가 다시 동작 안함)
      if newValue == STATS_TAG {
        statsViewModel.fetchStats()
        print("StatsViewModel refreshed!")
      }
    }
#if LITE_VERSION
    .task {
      await appOpenAdManager.loadAd()
    }
    .onChange(of: scenePhase) { _ in
      switch scenePhase {
      case .active:
        if !isFirstRun {
          let now = Date()
          if let last = lastAdShownDate {
            if now.timeIntervalSince(last) >= 30 {
              appOpenAdManager.showAdIfAvailable()
              lastAdShownDate = now
            }
          } else {
            appOpenAdManager.showAdIfAvailable()
            lastAdShownDate = now
          }
        }
      default:
        break
      }
    }
#endif
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
