//
//  IntervalPairCategory.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Foundation

enum IntervalPairCategory {
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
}
