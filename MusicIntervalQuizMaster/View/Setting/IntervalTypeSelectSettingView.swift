//
//  IntervalTypeSelectSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

// TODO: - 한줄씩 토글로 조절하는게 너무 불편, 버튼 그리드로 바꾸고 메인에서 바로 설정할 수 있게

struct IntervalTypeSelectSettingView: View {
  @EnvironmentObject var viewModel: SettingViewModel
  @State private var searchKeyword = ""
  
  var body: some View {
    Form {
      ForEach(1...13, id: \.self) { currentDegree in
        Section {
          ForEach(IntervalModifier.availableModifierList(of: currentDegree), id: \.self) { modifier in
            let degreeText = "\(modifier.localizedDescription) \(currentDegree)\(currentDegree.oridnalWithoutNumber)"
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
            Text("degree_settings")
          }
        }
      }
    }
    .navigationTitle("select_interval_type")
    .searchable(text: $searchKeyword, prompt: "search_prompt")
  }
}

#Preview {
  NavigationStack {
    IntervalTypeSelectSettingView()
      .environmentObject(SettingViewModel())
  }
}
