//
//  IntervalModifier.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Tonic

enum IntervalModifier: CustomStringConvertible, CaseIterable {
  case major, minor, perfect, diminished, augmented, doublyDiminished, doublyAugmented
  
  var description: String {
    switch self {
    case .major: "Major"
    case .minor: "minor"
    case .perfect: "Perfect"
    case .diminished: "diminished"
    case .augmented: "Augmented"
    case .doublyDiminished: "doubly diminished"
    case .doublyAugmented: "Doubly Augmented"
    }
  }
  
  var textFieldLocalizedDescription: String {
    switch self {
    case .major: "modifier_txf_major".localized
    case .minor: "modifier_txf_minor".localized
    case .perfect: "modifier_txf_perfect".localized
    case .diminished: "modifier_txf_diminished".localized
    case .augmented: "modifier_txf_augmented".localized
    case .doublyDiminished: "modifier_txf_2xdiminished".localized
    case .doublyAugmented: "modifier_txf_2xaugmented".localized
    }
  }
  
  var abbrDescription: String {
    switch self {
    case .major: "M"
    case .minor: "m"
    case .perfect: "P"
    case .diminished: "d"
    case .augmented: "A"
    case .doublyDiminished: "dd"
    case .doublyAugmented: "AA"
    }
  }
  
  var localizedDescription: String {
    switch self {
    case .major: "장"
    case .minor: "단"
    case .perfect: "완전"
    case .diminished: "감"
    case .augmented: "증"
    case .doublyDiminished: "겹감"
    case .doublyAugmented: "겹증"
    }
  }
  
  var mediumLocalizedDescription: String {
    switch self {
    case .major: "modifier_medium_major".localized
    case .minor: "modifier_medium_minor".localized
    case .perfect: "modifier_medium_perfect".localized
    case .diminished: "modifier_medium_diminished".localized
    case .augmented: "modifier_medium_augmented".localized
    case .doublyDiminished: "modifier_medium_2xdiminished".localized
    case .doublyAugmented: "modifier_medium_2xaugmented".localized
    }
  }
  
  var localizedAbbrDescription: String {
    switch self {
    case .major: "M"
    case .minor: "m"
    case .perfect: "P"
    case .diminished: "d"
    case .augmented: "A"
    case .doublyDiminished: "dd"
    case .doublyAugmented: "AA"
    }
  }
  
  var shortLocalizedDescription: String {
    switch self {
    case .major: "modifier_short_major".localized
    case .minor: "modifier_short_minor".localized
    case .perfect: "modifier_short_perfect".localized
    case .diminished: "modifier_short_diminished".localized
    case .augmented: "modifier_short_augmented".localized
    case .doublyDiminished: "modifier_short_doublyDiminished".localized
    case .doublyAugmented: "modifier_short_doublyAugmented".localized
    }
  }
  
  var chartLocalizedDescription: String {
    switch self {
    case .major: "chart_interval_major".localized
    case .minor: "chart_interval_minor".localized
    case .perfect: "chart_interval_perfect".localized
    case .diminished: "chart_interval_diminished".localized
    case .augmented: "chart_interval_augmented".localized
    case .doublyDiminished: "chart_interval_doubly_diminished".localized
    case .doublyAugmented: "chart_interval_doubly_augmented".localized
    }
  }
  
  var keyboardLocalizedDescription: String {
    switch self {
    case .major: "modifier_key_major".localized
    case .minor: "modifier_key_minor".localized
    case .perfect: "modifier_key_perfect".localized
    case .diminished: "modifier_key_diminished".localized
    case .augmented: "modifier_key_augmented".localized
    case .doublyDiminished: "modifier_key_2xdiminished".localized
    case .doublyAugmented: "modifier_key_2xaugmented".localized
    }
  }
  
  static func from(abbreviation: String) -> IntervalModifier? {
    switch abbreviation {
    case "M": .major
    case "m": .minor
    case "P": .perfect
    case "d": .diminished
    case "A": .augmented
    case "dd": doublyDiminished
    case "AA": .doublyAugmented
    default: nil
    }
  }
  
  func next(isPerfectGroup: Bool) -> Self? {
    switch self {
    case .major: .augmented
    case .minor: .major
    case .perfect: .augmented
    case .diminished:  isPerfectGroup ? .perfect : .minor
    case .doublyDiminished: .diminished
    case .augmented: .doublyAugmented
    case .doublyAugmented: nil
    }
  }
  
  func prev(isPerfectGroup: Bool) -> Self? {
    switch self {
    case .major: .minor
    case .minor: .diminished
    case .perfect: .diminished
    case .diminished:  .doublyDiminished
    case .doublyDiminished: nil
    case .augmented: isPerfectGroup ? .perfect : .major
    case .doublyAugmented: .augmented
    }
  }
  
  func move(isPerfectGroup: Bool, count: Int) -> Self? {
    if count == 0 {
      return self
    }
    
    var adjustedModifier: IntervalModifier? = self
    
    if count > 0 {
      for _ in stride(from: 1, through: count, by: 1) {
        adjustedModifier = adjustedModifier?.next(isPerfectGroup: isPerfectGroup)
      }
    } else {
      for _ in stride(from: -1, through: count, by: -1) {
        adjustedModifier = adjustedModifier?.prev(isPerfectGroup: isPerfectGroup)
      }
    }
    
    return adjustedModifier
  }
  
  static func availableModifierList(of degree: Int) -> [Self] {
    return if [1, 4, 5, 8, 11, 12].contains(degree) {
      [.perfect, .augmented, .diminished, .doublyAugmented, .doublyDiminished]
    } else {
      [.major, .minor, .augmented, .diminished, .doublyAugmented, .doublyDiminished]
    }
  }
}

