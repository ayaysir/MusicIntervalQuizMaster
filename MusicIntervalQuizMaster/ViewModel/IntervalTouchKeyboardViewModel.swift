//
//  IntervalTouchKeyboardViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import Foundation

final class IntervalTouchKeyboardViewModel: ObservableObject {
  @Published var intervalText: String = ""
  
  func appendText(_ text: String) {
    intervalText += text
  }
  
  func backspace() {
    if !intervalText.isEmpty {
      intervalText.removeLast()
    }
  }
}
