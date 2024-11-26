//
//  IntervalTypeSelectSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct IntervalTypeSelectSettingView: View {
  @EnvironmentObject var viewModel: SettingViewModel
  
  @AppStorage(.cfgIntervalFilterCompound) var cfgIntervalFilterCompound = false
  @AppStorage(.cfgIntervalFilterDoublyTritone) var cfgIntervalFilterDoublyTritone = false
  
  @State private var searchKeyword = ""
  
  var body: some View {
    Form {
      Section {
        Toggle("복합 음정 (9도 이상)", isOn: $cfgIntervalFilterCompound)
        Toggle("겹증/겹감", isOn: $cfgIntervalFilterDoublyTritone)
      } header: {
        Text("심화 내용의 문제 포함 여부")
      } footer: {
        Text("복합 음정, 겹증/겹감을 문제에 포함시키려면 On 하세요. 세부 설정보다 우선합니다.")
      }
      
      ForEach(1...13, id: \.self) { currentDegree in
        Section {
          ForEach(IntervalModifier.availableModifierList(of: currentDegree), id: \.self) { modifier in
            let degreeText = "\(modifier.localizedDescription) \(currentDegree)도"
            let abbrText = "\(modifier.localizedAbbrDescription)\(currentDegree)"
            
            if searchKeyword.isEmpty || degreeText.lowercased().contains(searchKeyword.lowercased()) || abbrText.lowercased().contains(searchKeyword.lowercased()) ||
                modifier.description.lowercased().contains(searchKeyword.lowercased())
            {
              Toggle(isOn: viewModel.binding(for: "\(modifier.abbrDescription)_\(currentDegree)")) {
                HStack {
                  Text(degreeText)
                  Text(abbrText)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                }
              }
            }
          }
        } header: {
          if currentDegree == 1 {
            Text("도수별 세부 설정")
          }
          
        }
      }
    }
    .navigationTitle("Select Interval Type")
    .searchable(text: $searchKeyword, prompt: "입력")
  }
}

#Preview {
  NavigationStack {
    IntervalTypeSelectSettingView()
      .environmentObject(SettingViewModel())
  }
}
