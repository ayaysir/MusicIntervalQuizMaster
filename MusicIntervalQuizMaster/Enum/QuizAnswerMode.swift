//
//  QuizAnswerMode.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/29/24.
//

import Foundation

enum QuizAnswerMode {
  case inQuiz, correct, wrong
  
  var systemImageString: String {
    switch self {
    case .inQuiz, .wrong:
      "return"
    case .correct:
      "arrow.turn.up.right"
    }
  }
}
