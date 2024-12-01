//
//  Int+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation

extension Int {
  var ordinal: String {
    let suffix: String
    let ones = self % 10
    let tens = (self / 10) % 10

    if tens == 1 {
      suffix = "th"
    } else {
      switch ones {
      case 1: suffix = "st"
      case 2: suffix = "nd"
      case 3: suffix = "rd"
      default: suffix = "th"
      }
    }
    return "\(self)\(suffix)"
  }
}
