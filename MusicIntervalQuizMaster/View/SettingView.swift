//
//  SettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct SettingView: View {
  @AppStorage(wrappedValue: true, .cfgNotesAscending) var cfgNotesAscending
  @AppStorage(wrappedValue: true, .cfgNotesDescending) var cfgNotesDescending
  @AppStorage(wrappedValue: true, .cfgNotesSimultaneously) var cfgNotesSimultaneously
  
  @StateObject var viewModel = SettingViewModel()
  /*
   buttonStyle
   .default - 파란색 버튼
   .plain - 일반 Text 형태 그대로 따라가는 버튼
   .bordered - 버튼의 tint색상을 기반으로 자동으로 테두리에 어울리는 색상이 생기는 버튼
   .borderedProminent - 버튼의 tint색상을 기반으로 텍스트가 `눈에 띄도록` 해주는 스타일
   .borderless - 테두리가 없는 버튼 (= .default와 동일)
   */
  
  private func selectableButton(_ title: String) -> some View {
    Button(title) {
      
    }
    // .frame(maxWidth: .infinity)
    .buttonStyle(.borderedProminent)
  }
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Toggle("동시", isOn: $cfgNotesAscending)
          Toggle("상행", isOn: $cfgNotesDescending)
          Toggle("하행", isOn: $cfgNotesSimultaneously)
        } header: {
          Text("음표 제시 방법")
        }
        
        Section {
          NavigationLink {
            IntervalTypeSelectSettingView()
              .environmentObject(viewModel)
          } label: {
            Text("선택하기 (\(viewModel.intervalStatesTurnOnCount)/\(viewModel.totalIntervalStatesCount))")
          }
        } header: {
          Text("출제 대상 음정 종류 선택")
        }
        
        Section {
          Toggle("음정 키보드를 누를 때", isOn: .constant(false))
          Toggle("정답일 때", isOn: .constant(false))
          Toggle("오답일 때", isOn: .constant(false))
        } header: {
          Text("햅틱")
        }
        
        // Text("\(viewModel.boolStates.count)")
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  SettingView()
}
