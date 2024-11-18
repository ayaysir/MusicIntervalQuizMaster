//
//  IntervalTypeSelectSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct IntervalTypeSelectSettingView: View {
  var body: some View {
    Form {
      ForEach(1...13, id: \.self) { index in
        Section {
          ForEach(IntervalModifier.availableModifierList(of: index), id: \.self) { modifier in
            Toggle(isOn: .constant(true)) {
              HStack {
                Text("\(modifier.localizedDescription) 1도")
                Text("\(modifier.localizedAbbrDescription)1")
                  .font(.system(size: 15))
                  .foregroundStyle(.gray)
              }
            }
          }
        } header: {
          Text("\(index)도")
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
  }
}
