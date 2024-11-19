//
//  IntervalTypeSelectSettingViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI


final class IntervalTypeSelectSettingViewModel: ObservableObject {
  @Published var boolStates: StringBoolDict {
    didSet {
      do {
        try UserDefaults.standard.setObject(boolStates, forKey: .cfgIntervalTypeStates)
      } catch {
        print("IntervalType BoolStates failed to save:", error)
      }
    }
  }
  
  init() {
    do {
      boolStates = try UserDefaults.standard.getObject(forKey: .cfgIntervalTypeStates, castTo: StringBoolDict.self)
    } catch {
      boolStates = [:]
    }
  }
  
  func binding(for key: String) -> Binding<Bool> {
    Binding {
      self.boolStates[key, default: true]
    } set: {
      self.boolStates[key] = $0
    }
  }
}
