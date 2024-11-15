//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = ContentViewModel()
  @StateObject var keyboardViewModel = IntervalTouchKeyboardViewModel()
  
  var body: some View {
    VStack {
      Text("Count: \(viewModel.currentPairCount)")
      Text(viewModel.currentPair.description)
      HStack {
        Button {
          viewModel.prev()
        } label: {
          Text("prev")
        }
        Button {
          viewModel.next()
        } label: {
          Text("next")
        }
      }
      
      // TextField("Input", text: $keyboardViewModel.intervalText)
      ReadOnlyTextFieldRPView(text: $keyboardViewModel.intervalText)
        .frame(height: 30)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
      
      IntervalTouchKeyboardView()
        .environmentObject(keyboardViewModel)
    }
  }
}

#Preview {
  ContentView()
}
