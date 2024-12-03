//
//  AppSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/27/24.
//

import SwiftUI

struct AppSettingView: View {
  @AppStorage(.cfgHapticPressedIntervalKeyboard) var cfgHapicPressed = true
  @AppStorage(.cfgHapticAnswer) var cfgHapicAnswer = true
  @AppStorage(.cfgHapticWrong) var cfgHapicWrong = true
  @AppStorage(.cfgAppAutoNextMove) var cfgAppAutoNextMove = false
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  @AppStorage(.cfgAppAppearance) var cfgAppAppearance = 0
  
  private var stepperLabel: some View {
    HStack {
      Text("problem_solving_timer")
      Spacer()
      Text(cfgTimerSeconds == 0 ? "unlimited".localized : "\(cfgTimerSeconds)\("time_second_abbr".localized)")
        .foregroundColor(.gray)
    }
  }
  
  var body: some View {
    Form {
      Section {
        if ProcessInfo.processInfo.isiOSAppOnMac {
          ForMacStepper(value: $cfgTimerSeconds, range: 0...60, step: 5) {
            stepperLabel
          }
        } else {
          Stepper(value: $cfgTimerSeconds, in: 0...60, step: 5) {
            stepperLabel
          }
        }
      } header: {
        Text("timer_problem_solving_within_limit")
      } footer: {
        Text("timer_limit_description")
      }
      
      Section {
        Toggle("auto_move_to_next_problem_toggle", isOn: $cfgAppAutoNextMove)
      } header: {
        Text("auto_move_to_next_problem")
      }
      
      Section {
        Toggle("haptic_when_key_pressed", isOn: $cfgHapicPressed)
        Toggle("haptic_when_correct", isOn: $cfgHapicAnswer)
        Toggle("haptic_when_wrong", isOn: $cfgHapicWrong)
      } header: {
        Text("haptic_when_key_pressed".localized)
      }
      
      Section("appearance") {
        appearanceButton("appearance_use_device_theme".localized, 0)
        appearanceButton("appearance_light_theme".localized, 1)
        appearanceButton("appearance_dark_theme".localized, 2)
      }
    }
    .navigationTitle("app_settings")
  }
}

extension AppSettingView {
  private func appearanceButton(_ title: String, _ cfgValue: Int) -> some View {
    Button(action: {
      cfgAppAppearance = cfgValue
    }) {
      HStack {
        Text(title)
        Spacer()
        if cfgAppAppearance == cfgValue {
          Image(systemName: "checkmark")
            .foregroundColor(.blue) // 체크 표시 색상
        }
      }
    }
    .foregroundStyle(.foreground)
  }
}

#Preview {
  NavigationStack {
    AppSettingView()
  }
}
