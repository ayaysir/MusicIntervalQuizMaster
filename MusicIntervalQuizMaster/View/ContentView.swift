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
  
  private func intervalTextField(_ text: String, backgroundColor: Color, isLeading: Bool = true) -> some View {
    Text(text == "0" ? "-" : text)
      .padding()
      .font(.system(size: 30).bold())
      .frame(width: 100, height: 50, alignment: isLeading ? .leading : .trailing)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 5))
  }
  
  var body: some View {
    VStack {
      MusiqwikView(pair: viewModel.currentPair)
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
      
      HStack {
        intervalTextField(
          "\(keyboardViewModel.intervalModifier)",
          backgroundColor: .red.opacity(0.5),
          isLeading: false
        )
        intervalTextField(
          "\(keyboardViewModel.intervalNumber)",
          backgroundColor: .cyan.opacity(0.5)
        )
      }
      
      IntervalTouchKeyboardView()
        .environmentObject(keyboardViewModel)
    }
  }
}

#Preview {
  ContentView()
}
