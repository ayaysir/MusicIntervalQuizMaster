//
//  IntervalTypeSelectSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

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
