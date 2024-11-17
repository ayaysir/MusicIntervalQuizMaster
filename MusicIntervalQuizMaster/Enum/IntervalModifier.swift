//
//  IntervalModifier.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Tonic

enum IntervalModifier: CustomStringConvertible {
  var description: String {
    switch self {
    case .major:
      "M"
    case .minor:
      "m"
    case .perfect:
      "P"
    case .diminished:
      "d"
    case .doublyDiminished:
      "dd"
    case .augmented:
      "A"
    case .doublyAugmented:
      "AA"
    }
  }
  
  case major, minor, perfect, diminished, doublyDiminished, augmented, doublyAugmented
}

