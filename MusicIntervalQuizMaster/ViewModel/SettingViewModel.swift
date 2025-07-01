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
      boolStates = try store.getObject(forKey: .cfgIntervalTypeStates, castTo: StringBoolDict.self)
      
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
  
  /// 키 이름으로 바인딩 Bool 변수 생성
  /// ```
  /// 키 이름: "\(modifier.abbrDescription)_\(currentDegree)"
  /// ```
  func binding(for key: String) -> Binding<Bool> {
    Binding {
      self.boolStates[key, default: true]
    } set: {
      self.boolStates[key] = $0
      
      self.saveBoolStates()
    }
  }
  
  func turnOnAllStates() {
    // boolStates [String: Bool] 의 모든 값을 true로
    boolStates = boolStates.mapValues { _ in true }
  }
  
  func turnOnStates(keyPrefix: String) {
    // boolStates [String: Bool] 의 키값이 "\(keyPrefix)_" 로 시작하는 모든 키값을 true로
    for key in boolStates.keys where key.hasPrefix("\(keyPrefix)_") {
      boolStates[key] = true
    }
  }
  
  func turnOnStates(keySuffix: String) {
    for key in boolStates.keys where key.hasSuffix(keySuffix) {
      boolStates[key] = true
    }
  }
  
  private func saveBoolStates() {
    do {
      try store.setObject(boolStates, forKey: .cfgIntervalTypeStates)
    } catch {
      print("IntervalType BoolStates failed to save:", error)
    }
  }
}
