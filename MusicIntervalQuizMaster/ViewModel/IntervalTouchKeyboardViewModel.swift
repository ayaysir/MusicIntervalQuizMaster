//
//  IntervalTouchKeyboardViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import Foundation
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

final class IntervalTouchKeyboardViewModel: ObservableObject {
  @Published var intervalModifier: IntervalModifier = .major
  @Published var intervalNumber: Int = 0
  
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
