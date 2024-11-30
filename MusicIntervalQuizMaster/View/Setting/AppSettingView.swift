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
      Text("문제풀이 타이머")
      Spacer()
      Text(cfgTimerSeconds == 0 ? "제한없음" : "\(cfgTimerSeconds)초")
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
        Text("타이머")
      }
      
      Section {
        Toggle("바로 다음문제로", isOn: $cfgAppAutoNextMove)
      } header: {
        Text("정답인 경우 다음 문제로 자동으로 이동")
      }
      
      Section {
        Toggle("음정 키보드를 누를 때", isOn: $cfgHapicPressed)
        Toggle("정답일 때", isOn: $cfgHapicAnswer)
        Toggle("오답일 때", isOn: $cfgHapicWrong)
      } header: {
        Text("햅틱")
      }
      
      Section("Appearance") {
        appearanceButton("📱 Use device theme", 0)
        appearanceButton("☀️ Light theme", 1)
        appearanceButton("🌘 Dark theme", 2)
      }
    }
    .navigationTitle("App Settings")
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
