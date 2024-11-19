//
//  IntervalTypeSelectSettingViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

final class SettingViewModel: ObservableObject {
  @Published private(set) var boolStates: StringBoolDict
  
  init() {
    do {
      boolStates = try UserDefaults.standard.getObject(forKey: .cfgIntervalTypeStates, castTo: StringBoolDict.self)
      
      // boolStates = INTERVAL_TYPE_STATE_FIRST; saveBoolStates()
    } catch {
      boolStates = INTERVAL_TYPE_STATE_FIRST
      saveBoolStates()
    }
  }
  
  var intervalStatesTurnOnCount: Int {
    boolStates.filter { $0.value }.count
  }
  
  var totalIntervalStatesCount: Int {
    (1...13).reduce(0) { partialResult, degree in
      partialResult + IntervalModifier.availableModifierList(of: degree).count
    }
  }
  
  func binding(for key: String) -> Binding<Bool> {
    Binding {
      self.boolStates[key, default: true]
    } set: {
      self.boolStates[key] = $0
      
      self.saveBoolStates()
    }
  }
  
  private func saveBoolStates() {
    do {
      try UserDefaults.standard.setObject(boolStates, forKey: .cfgIntervalTypeStates)
    } catch {
      print("IntervalType BoolStates failed to save:", error)
    }
  }
}
