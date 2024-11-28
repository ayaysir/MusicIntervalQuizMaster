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
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Stepper(value: $cfgTimerSeconds, in: 0...60, step: 5) {
            HStack {
              Text("문제풀이 타이머")
              Spacer()
              Text(cfgTimerSeconds == 0 ? "제한없음" : "\(cfgTimerSeconds)초")
                .foregroundColor(.gray)
            }
          }
        } header: {
          Text("타이머")
        }
        
        Section {
          Toggle("음정 키보드를 누를 때", isOn: $cfgHapicPressed)
          Toggle("정답일 때", isOn: $cfgHapicAnswer)
          Toggle("오답일 때", isOn: $cfgHapicWrong)
        } header: {
          Text("햅틱")
        }
        
        Section {
          Toggle("바로 다음문제로", isOn: $cfgAppAutoNextMove)
        } header: {
          Text("정답인 경우 다음 문제로 자동으로 이동")
        }
      }
      .navigationTitle("App Settings")
    }
  }
}

#Preview {
  AppSettingView()
}
