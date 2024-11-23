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
  
  @State private var workItem: DispatchWorkItem?
  
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
        .onAppear {
          playSounds()
        }
        .onChange(of: viewModel.currentPair) { _ in
          playSounds()
        }
        .onTapGesture {
          playSounds()
        }
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
  
  private func playSounds() {
    SoundManager.shared.stopAllSounds()
    SoundManager.shared.cleanupFinishedPlayers()
    if let workItem {
      workItem.cancel()
    }
    
    workItem = .init {
      viewModel.currentPair.endNote.playSound()
    }
    
    switch viewModel.currentPair.category {
    case .ascending, .descending:
      viewModel.currentPair.startNote.playSound()
      if let workItem {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: workItem)
      }
    case .simultaneously:
      viewModel.currentPair.startNote.playSound()
      viewModel.currentPair.endNote.playSound()
    }
  }
}

#Preview {
  QuizView()
}
