//
//  MusicIntervalQuizMasterApp.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

@main
struct MusicIntervalQuizMasterApp: App {
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
    
    store.set(true, forKey: .cfgAccidentalSharp)
    store.set(true, forKey: .cfgAccidentalFlat)
    store.set(false, forKey: .cfgAccidentalDoubleSharp)
    store.set(false, forKey: .cfgAccidentalDoubleFlat)
  }
}

func checkAppFirstrunOrUpdateStatus(firstrun: () -> (), updated: () -> (), nothingChanged: () -> ()) {
  let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  let versionOfLastRun = store.object(forKey: "VersionOfLastRun") as? String
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
  
  store.set(currentVersion, forKey: "VersionOfLastRun")
  store.synchronize()
}
