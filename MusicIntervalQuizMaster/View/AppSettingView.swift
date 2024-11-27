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
  
  var body: some View {
    NavigationStack {
      Form {
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
