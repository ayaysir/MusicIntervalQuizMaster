//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct QuizView: View {
  @StateObject var viewModel = QuizViewModel()
  @StateObject var keyboardViewModel = IntervalTouchKeyboardViewModel()
  
  private func intervalTextField(_ text: String, backgroundColor: Color, isLeading: Bool = true) -> some View {
    Text(text == "0" ? "-" : text)
      .padding()
      .font(.system(size: 25).bold())
      .frame(height: 50, alignment: isLeading ? .leading : .trailing)
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 5))
  }
  
  var body: some View {
    VStack {
      Spacer()
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
  QuizView()
}
