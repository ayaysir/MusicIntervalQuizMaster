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
      "status_solved".localized
    case .unsolved:
      "status_unsolved".localized
    case .correct100:
      "100%"
    case .correct0:
      "0%"
    case .rate1_5:
      "status_rate1_5".localized
    case .rate2_5:
      "status_rate2_5".localized
    case .rate3_5:
      "status_rate3_5".localized
    case .rate4_5:
      "status_rate4_5".localized
    case .rate5_5:
      "status_rate5_5".localized
    }
  }
}
