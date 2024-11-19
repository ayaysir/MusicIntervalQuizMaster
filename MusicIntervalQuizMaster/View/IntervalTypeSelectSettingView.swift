//
//  IntervalTypeSelectSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct IntervalTypeSelectSettingView: View {
  @EnvironmentObject var viewModel: SettingViewModel
  
  var body: some View {
    Form {
      ForEach(1...13, id: \.self) { currentDegree in
        Section {
          ForEach(IntervalModifier.availableModifierList(of: currentDegree), id: \.self) { modifier in
            Toggle(isOn: viewModel.binding(for: "\(modifier.abbrDescription)_\(currentDegree)")) {
              HStack {
                // Text("\(modifier.abbrDescription)_\(currentDegree)")
                Text("\(modifier.localizedDescription) \(currentDegree)도")
                Text("\(modifier.localizedAbbrDescription)\(currentDegree)")
                  .font(.system(size: 15))
                  .foregroundStyle(.gray)
              }
            }
          }
        } header: {
          Text("\(currentDegree)도")
        }
      }
    }
    .navigationTitle("Select Interval Type")
    .searchable(text: .constant("M1"), prompt: "입력")
  }
}

#Preview {
  NavigationStack {
    IntervalTypeSelectSettingView()
      .environmentObject(SettingViewModel())
  }
}
