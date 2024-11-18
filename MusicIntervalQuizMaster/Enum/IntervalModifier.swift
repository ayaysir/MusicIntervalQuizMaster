//
//  IntervalModifier.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Tonic

enum IntervalModifier: CustomStringConvertible, CaseIterable {
  case major, minor, perfect, diminished, doublyDiminished, augmented, doublyAugmented
  
  var description: String {
    switch self {
    case .major:
      "Major"
    case .minor:
      "minor"
    case .perfect:
      "Perfect"
    case .diminished:
      "diminished"
    case .augmented:
      "Augmented"
    case .doublyDiminished:
      "doubly diminished"
    case .doublyAugmented:
      "Doubly Augmented"
    }
  }
  
  var localizedDescription: String {
    switch self {
    case .major:
      "장"
    case .minor:
      "단"
    case .perfect:
      "완전"
    case .diminished:
      "감"
    case .augmented:
      "증"
    case .doublyDiminished:
      "겹감"
    case .doublyAugmented:
      "겹증"
    }
  }
  
  var localizedAbbrDescription: String {
    switch self {
    case .major:
      "M"
    case .minor:
      "m"
    case .perfect:
      "P"
    case .diminished:
      "d"
    case .augmented:
      "A"
    case .doublyDiminished:
      "dd"
    case .doublyAugmented:
      "AA"
    }
  }
  
  static func availableModifierList(of degree: Int) -> [IntervalModifier] {
    return if [1, 4, 5, 8, 11, 12].contains(degree) {
      [.perfect, .augmented, .diminished, .doublyAugmented, .doublyDiminished]
    } else {
      [.major, .minor, .augmented, .diminished, .doublyAugmented, .doublyDiminished]
    }
  }
}

