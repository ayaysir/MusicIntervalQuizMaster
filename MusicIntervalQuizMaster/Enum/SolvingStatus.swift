//
//  SolvingStatus.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/2/24.
//

import Foundation

enum SolvingStatus: CaseIterable {
  case solved, unsolved, correct100, correct0
  case rate1_5, rate2_5, rate3_5, rate4_5, rate5_5
  
  var localizedDescription: String {
    switch self {
    case .solved:
      "Solved"
    case .unsolved:
      "Unsolved"
    case .correct100:
      "100%"
    case .correct0:
      "0%"
    case .rate1_5:
      "Very Low"
    case .rate2_5:
      "Low"
    case .rate3_5:
      "Moderate"
    case .rate4_5:
      "High"
    case .rate5_5:
      "Very High"
    }
  }
}
