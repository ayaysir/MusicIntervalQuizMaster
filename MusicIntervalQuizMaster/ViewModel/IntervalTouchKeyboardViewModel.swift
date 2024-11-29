//
//  IntervalTouchKeyboardViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import Foundation

final class IntervalTouchKeyboardViewModel: ObservableObject {
  @Published var intervalModifier: IntervalModifier = .major
  @Published var intervalNumber: Int = 0
  @Published var answerMode: QuizAnswerMode = .inQuiz
  
  var intervalAbbrDescription: String {
    "\(intervalModifier.abbrDescription)\(intervalNumber)"
  }
  
  func setIntervalNumber(_ input: Int) {
    intervalNumber = switch intervalNumber {
    case 1:
      if 0...3 ~= input {
        10 + input
      } else {
        input
      }
    default:
      input
    }
  }
}
