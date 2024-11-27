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
