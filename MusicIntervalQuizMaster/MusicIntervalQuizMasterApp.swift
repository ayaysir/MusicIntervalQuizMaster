//
//  MusicIntervalQuizMasterApp.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

@main
struct MusicIntervalQuizMasterApp: App {
  let store = UserDefaults.standard
  
  init() {
    FontManager.registerFonts()
    
    checkAppFirstrunOrUpdateStatus {
      initConfigValues()
    } updated: {
      
    } nothingChanged: {
      
    }
  }
  
  var body: some Scene {
    WindowGroup {
      MainTabBarView()
    }
  }
  
  private func initConfigValues() {
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
  }
}

func checkAppFirstrunOrUpdateStatus(firstrun: () -> (), updated: () -> (), nothingChanged: () -> ()) {
  let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  let versionOfLastRun = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String
  // print(#function, currentVersion ?? "", versionOfLastRun ?? "")
  
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
  
  UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
  UserDefaults.standard.synchronize()
}
