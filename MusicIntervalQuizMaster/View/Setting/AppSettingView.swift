//
//  AppSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/27/24.
//

import SwiftUI

struct AppSettingView: View {
  // MARK: - View main
  
  @AppStorage(.cfgHapticPressedIntervalKeyboard) var cfgHapicPressed = true
  @AppStorage(.cfgHapticAnswer) var cfgHapicAnswer = true
  @AppStorage(.cfgHapticWrong) var cfgHapicWrong = true
  @AppStorage(.cfgAppAutoNextMove) var cfgAppAutoNextMove = false
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  @AppStorage(.cfgAppAppearance) var cfgAppAppearance = 0
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          if ProcessInfo.processInfo.isiOSAppOnMac {
            ForMacStepper(value: $cfgTimerSeconds, range: 0...60, step: 5) {
              StepperLabel
            }
          } else {
            Stepper(value: $cfgTimerSeconds, in: 0...60, step: 5) {
              StepperLabel
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
          Text("haptic_feedback".localized)
        }
        
        Section("appearance") {
          AppearanceButton("appearance_use_device_theme".localized, 0)
          AppearanceButton("appearance_light_theme".localized, 1)
          AppearanceButton("appearance_dark_theme".localized, 2)
        }
      }
      .navigationTitle("app_settings")
    }
  }
}

extension AppSettingView {
  // MARK: - View segments
  
  private var StepperLabel: some View {
    HStack {
      Text("problem_solving_timer")
      Spacer()
      Text(cfgTimerSeconds == 0 ? "unlimited".localized : "\(cfgTimerSeconds)\("time_second_abbr".localized)")
        .foregroundColor(.gray)
    }
  }
  
  private func AppearanceButton(_ title: String, _ cfgValue: Int) -> some View {
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
  AppSettingView()
}
