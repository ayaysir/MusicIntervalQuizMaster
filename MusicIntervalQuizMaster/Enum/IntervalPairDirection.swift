//
//  IntervalPairCategory.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Foundation

enum IntervalPairDirection {
  case ascending, descending, simultaneously
  
  var dataDescription: String {
    switch self {
    case .ascending:
      "asc"
    case .descending:
      "dsc"
    case .simultaneously:
      "sml"
    }
  }
  
  init?(dataDescription: String?) {
    switch dataDescription {
    case "asc":
      self = .ascending
    case "dsc":
      self = .descending
    case "sml":
      self = .simultaneously
    default:
      return nil // 지원되지 않는 값인 경우
    }
  }
}
