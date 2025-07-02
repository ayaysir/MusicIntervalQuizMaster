//
//  MusicIntervalQuizMasterApp.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

@main
struct MusicIntervalQuizMasterApp: App {
  @AppStorage(.cfgAppAppearance) private var cfgAppAppearance = 0
  
  init() {
    FontManager.registerFonts()
    
    checkAppFirstrunOrUpdateStatus {
      
    } updated: {
      // Whats New: latest v 1.3.0
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        InstantSheet.show(
          hostingView: WhatsNewView(
            marketingVersion: "1.3.0",
            features: WhatsNewArchive.shared("1.3.0") ?? []
          )
        )
      }
    } nothingChanged: {
      if !store.bool(forKey: .checkInitConfigCompleted) {
        Self.initConfigValues()
      }
    }
  }
  
  var body: some Scene {
    WindowGroup {
      MainTabBarView()
        .preferredColorScheme(ColorScheme.fromAppAppearance(cfgAppAppearance))
    }
  }
  
  static func initConfigValues() {
    // 최초 실행 시 설정값
    try? store.setObject(INTERVAL_TYPE_STATE_FIRST, forKey: .cfgIntervalTypeStates)
    
    store.set(true, forKey: .cfgNotesAscending)
    store.set(true, forKey: .cfgNotesDescending)
    store.set(true, forKey: .cfgNotesSimultaneously)
    
    store.set(true, forKey: .cfgClefTreble)
    store.set(true, forKey: .cfgClefBass)
    store.set(false, forKey: .cfgClefAlto)
    
    store.set(true, forKey: .cfgHapticPressedIntervalKeyboard)
    store.set(true, forKey: .cfgHapticAnswer)
    store.set(true, forKey: .cfgHapticWrong)
    
    store.set(true, forKey: .cfgAccidentalSharp)
    store.set(true, forKey: .cfgAccidentalFlat)
    store.set(false, forKey: .cfgAccidentalDoubleSharp)
    store.set(false, forKey: .cfgAccidentalDoubleFlat)
    
    store.set(false, forKey: .cfgIntervalFilterCompound)
    store.set(false, forKey: .cfgIntervalFilterDoublyTritone)
    
    store.set(0, forKey: .cfgAppAppearance)
    store.set(false, forKey: .cfgAppAutoNextMove)
    
    store.set(30, forKey: .cfgTimerSeconds)
    
    // set completed status
    store.set(true, forKey: .checkInitConfigCompleted)
  }
}

func checkAppFirstrunOrUpdateStatus(firstrun: () -> (), updated: () -> (), nothingChanged: () -> ()) {
  let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  let versionOfLastRun = store.object(forKey: "VersionOfLastRun") as? String
  print(#function, currentVersion ?? "", versionOfLastRun ?? "")
  
  if versionOfLastRun == nil {
    // First start after installing the app
    firstrun()
    
  } else if versionOfLastRun != currentVersion {
    // App was updated since last run
    updated()
    
  } else {
    // nothing changed
    nothingChanged()
  }
  
  store.set(currentVersion, forKey: "VersionOfLastRun")
  store.synchronize()
}
